#!/usr/bin/env python3
"""
Prepares App Store Connect & Apple Developer Portal state for headless TestFlight CI:
1. Normalizes ASC_PRIVATE_KEY (accepts raw PEM or base64, even if mobile copy/paste altered whitespace)
   and writes ~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8 with 0600 permissions.
2. Auto-registers the Bundle ID via App Store Connect API (POST /v1/bundleIds) if not yet registered.
3. Checks whether the App record exists in App Store Connect (GET /v1/apps) and computes the next
   monotonically increasing build number so uploads never fail with Redundant Binary Upload.
"""

import base64
import os
import re
import sys
import time
from pathlib import Path

import jwt
import requests

ASC_BASE = "https://api.appstoreconnect.apple.com/v1"


def normalize_p8_key(raw_value: str) -> str:
    value = raw_value.strip()
    if "BEGIN PRIVATE KEY" not in value:
        try:
            decoded = base64.b64decode(value).decode("utf-8").strip()
            if "BEGIN PRIVATE KEY" in decoded:
                value = decoded
        except Exception:
            pass

    # Extract base64 body between PEM headers (handles mobile copy-paste line flattening)
    body = re.sub(r"-----BEGIN PRIVATE KEY-----", "", value)
    body = re.sub(r"-----END PRIVATE KEY-----", "", body)
    body = re.sub(r"\s+", "", body)

    wrapped = "\n".join(body[i : i + 64] for i in range(0, len(body), 64))
    return f"-----BEGIN PRIVATE KEY-----\n{wrapped}\n-----END PRIVATE KEY-----\n"


def make_jwt(key_id: str, issuer_id: str, private_key_pem: str) -> str:
    now = int(time.time())
    payload = {
        "iss": issuer_id,
        "iat": now - 30,
        "exp": now + 900,
        "aud": "appstoreconnect-v1",
    }
    headers = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    return jwt.encode(payload, private_key_pem, algorithm="ES256", headers=headers)


def append_summary(markdown: str) -> None:
    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as f:
            f.write(markdown + "\n")


def write_output(key: str, value: str) -> None:
    out_path = os.environ.get("GITHUB_OUTPUT")
    if out_path:
        with open(out_path, "a", encoding="utf-8") as f:
            f.write(f"{key}={value}\n")


def main() -> int:
    key_id = os.environ["ASC_KEY_ID"].strip()
    issuer_id = os.environ["ASC_ISSUER_ID"].strip()
    raw_key = os.environ["ASC_PRIVATE_KEY"]
    bundle_id = os.environ["BUNDLE_ID"].strip()
    run_number = int(os.environ.get("GITHUB_RUN_NUMBER", "1"))

    pem = normalize_p8_key(raw_key)

    key_dir = Path.home() / ".appstoreconnect" / "private_keys"
    key_dir.mkdir(parents=True, exist_ok=True)
    key_file = key_dir / f"AuthKey_{key_id}.p8"
    key_file.write_text(pem, encoding="utf-8")
    key_file.chmod(0o600)
    write_output("key_path", str(key_file))
    print(f"Wrote App Store Connect key to {key_file}")

    token = make_jwt(key_id, issuer_id, pem)
    session = requests.Session()
    session.headers.update(
        {
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        }
    )

    # 1. Ensure Bundle ID is registered in Apple Developer Portal
    resp = session.get(f"{ASC_BASE}/bundleIds", params={"filter[identifier]": bundle_id, "limit": 50}, timeout=30)
    if resp.status_code != 200:
        print(f"Warning: GET /v1/bundleIds returned {resp.status_code}: {resp.text}")
    else:
        items = resp.json().get("data", [])
        exact = [item for item in items if item.get("attributes", {}).get("identifier") == bundle_id]
        if exact:
            print(f"Bundle ID '{bundle_id}' is already registered.")
        else:
            print(f"Registering Bundle ID '{bundle_id}' via App Store Connect API...")
            create_resp = session.post(
                f"{ASC_BASE}/bundleIds",
                json={
                    "data": {
                        "type": "bundleIds",
                        "attributes": {
                            "identifier": bundle_id,
                            "name": "iOS Connections Demo",
                            "platform": "IOS",
                        },
                    }
                },
                timeout=30,
            )
            if create_resp.status_code in (200, 201):
                print(f"Successfully registered Bundle ID '{bundle_id}'!")
            else:
                print(f"Note: Could not auto-register Bundle ID ({create_resp.status_code}): {create_resp.text}")

    # 2. Check App record in App Store Connect & compute next build number
    apps_resp = session.get(f"{ASC_BASE}/apps", params={"filter[bundleId]": bundle_id, "limit": 20}, timeout=30)
    app_id = None
    if apps_resp.status_code == 200:
        apps = [
            a for a in apps_resp.json().get("data", []) if a.get("attributes", {}).get("bundleId") == bundle_id
        ]
        if apps:
            app_id = apps[0]["id"]
            print(f"Found App Store Connect app record (id={app_id}) for '{bundle_id}'.")

    if not app_id:
        msg = (
            f"### ⚠️ One-Time App Store Connect Record Needed\n\n"
            f"Bundle ID **`{bundle_id}`** is registered in your Apple Developer account, "
            f"but no App record exists for it in **App Store Connect** yet.\n\n"
            f"On your iPhone or browser, open **[App Store Connect → Apps](https://appstoreconnect.apple.com/apps)**, "
            f"tap **`+` → New App**, and fill in:\n"
            f"- **Platforms:** iOS\n"
            f"- **Name:** `iOS Connections` *(if already taken on the store, pick e.g. `iOS Connections Demo` — "
            f"your iPhone Home Screen will still say **iOS Connections**)*\n"
            f"- **Primary Language:** English (U.S.)\n"
            f"- **Bundle ID:** `{bundle_id}`\n"
            f"- **SKU:** `ios-connections-demo`\n\n"
            f"Then re-run this workflow!"
        )
        print(msg)
        append_summary(msg)
        write_output("app_ready", "false")
        write_output("build_number", str(run_number))
        return 1

    highest_build = 0
    builds_resp = session.get(f"{ASC_BASE}/builds", params={"filter[app]": app_id, "limit": 100}, timeout=30)
    if builds_resp.status_code == 200:
        for b in builds_resp.json().get("data", []):
            ver_str = b.get("attributes", {}).get("version", "")
            if ver_str.isdigit():
                highest_build = max(highest_build, int(ver_str))

    next_build = max(highest_build + 1, run_number)
    print(f"Using build number: {next_build} (highest in ASC: {highest_build}, run_number: {run_number})")
    write_output("app_ready", "true")
    write_output("build_number", str(next_build))
    return 0


if __name__ == "__main__":
    sys.exit(main())
