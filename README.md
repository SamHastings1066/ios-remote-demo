# iOS Connections 💘

A playful SwiftUI demo app built remotely with **Antigravity** and delivered directly to iPhone via **GitHub Actions → TestFlight** — **without ever connecting an iPhone to a Mac or manually exporting certificates**.

## What's Inside

**iOS Connections** is a parody dating app featuring Google's 6 flagship iOS apps as singles looking for a spot on your Home Screen Dock:

1. **Gmail** — *Inbox Zero romantic*
2. **YouTube** — *Just one more video at 2 AM...*
3. **Google Search** — *Finishes your sentences in 0.24s*
4. **Chrome** — *487 open tabs (`:D`), zero regrets*
5. **Gemini** — *Sparkly, multimodal & curious*
6. **Google Maps** — *Knows every 4.9★ taco spot & never yells when you miss an exit*

Includes both an interactive **Discover Swipe Deck** (drag gestures, `CONNECT` / `PASS` stamps, rewind, match toasts) and an **All 6 Apps** directory grid with full Hinge-style profile sheets.

---

## Zero-Mac Delivery to iPhone (GitHub Actions → TestFlight)

This repository uses **XcodeGen** + **Xcode Cloud-Managed Distribution Signing** (`-allowProvisioningUpdates` + App Store Connect API Key). Apple generates and manages the distribution certificate and provisioning profile in the cloud during CI, so **you never need Keychain Access, CSR files, or `.p12` certificates**.

### Step 1: Create an App Store Connect API Key (on Web / Mobile Safari)
1. Open **[App Store Connect → Users and Access → Integrations → App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api)**.
2. Tap **`+`** under **Team Keys**, name it `GitHub Actions`, and choose the **Admin** role *(Admin is required by Apple for Xcode Cloud-Managed Signing to manage distribution certificates automatically)*.
3. Note your **Issuer ID** (UUID at top) and **Key ID**, and download **`AuthKey_<KEY_ID>.p8`**.
4. Find your 10-character **Team ID** at **[Apple Developer Membership Details](https://developer.apple.com/account#MembershipDetailsCard)**.

### Step 2: Add 4 Secrets to This GitHub Repository
Open **[Repository Settings → Secrets and variables → Actions](../../settings/secrets/actions)** and add:

| Secret | Value |
| --- | --- |
| `APPLE_TEAM_ID` | Your 10-character Apple Developer Team ID (e.g. `A1B2C3D4E5`) |
| `ASC_KEY_ID` | Your App Store Connect API Key ID (e.g. `2X9R4HXF34`) |
| `ASC_ISSUER_ID` | Your App Store Connect Issuer ID (UUID) |
| `ASC_PRIVATE_KEY` | Full contents of `AuthKey_<KEY_ID>.p8` *(raw PEM text or base64 both work)* |

*(Optional)* If you want to customize the Bundle ID (default: `com.samhastings.iosconnections`), add a Repository Variable named `IOS_BUNDLE_ID`.

### Step 3: Create the App Shell in App Store Connect (One-Time, 30 Seconds)
1. First, trigger **[Build & Deliver to TestFlight](../../actions/workflows/ios-testflight.yml)** once (or register the Bundle ID first) — our `scripts/asc_prepare.py` step **automatically registers the Bundle ID** (`com.samhastings.iosconnections`) on the Apple Developer Portal for you!
2. Open **[App Store Connect → Apps](https://appstoreconnect.apple.com/apps)** → **`+` → New App**:
   - **Platform:** iOS
   - **Name:** `iOS Connections` *(if that global store name is already taken, enter e.g. `iOS Connections Demo` — the icon label on your iPhone Home Screen will still say **iOS Connections**)*
   - **Primary Language:** English (U.S.)
   - **Bundle ID:** `com.samhastings.iosconnections` *(or your custom `IOS_BUNDLE_ID`)*
   - **SKU:** `ios-connections-demo`

### Step 4: Install on Your iPhone via TestFlight
1. Trigger **Run workflow** on **[Build & Deliver to TestFlight](../../actions/workflows/ios-testflight.yml)** (or push any commit to `main`).
2. Once the workflow finishes (~2 minutes) and Apple completes processing (~3 minutes):
   - Open your app in **App Store Connect → TestFlight → Internal Testing**, create an internal group if you haven't yet, and add yourself.
   - Open the **TestFlight** app on your iPhone and tap **Install**! *(Export compliance `ITSAppUsesNonExemptEncryption = NO` is already baked into `Info.plist`, so no compliance questionnaire is required.)*
