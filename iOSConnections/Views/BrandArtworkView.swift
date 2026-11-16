import SwiftUI

struct BrandArtworkView: View {
    let profile: AppProfile
    var compact: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: profile.heroGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Ambient soft glow orbs
            GeometryReader { geo in
                Circle()
                    .fill(.white.opacity(0.14))
                    .frame(width: geo.size.width * 0.72)
                    .blur(radius: 26)
                    .offset(x: -geo.size.width * 0.18, y: -geo.size.height * 0.16)

                Circle()
                    .fill(profile.accentColor.opacity(0.32))
                    .frame(width: geo.size.width * 0.65)
                    .blur(radius: 30)
                    .offset(x: geo.size.width * 0.35, y: geo.size.height * 0.28)
            }

            Group {
                switch profile.kind {
                case .gmail:
                    gmailEmblem
                case .youtube:
                    youtubeEmblem
                case .search:
                    searchEmblem
                case .chrome:
                    chromeEmblem
                case .gemini:
                    geminiEmblem
                case .maps:
                    mapsEmblem
                }
            }
            .scaleEffect(compact ? 0.62 : 1.0)
            .offset(y: compact ? -6 : -18)
        }
        .clipped()
    }

    // MARK: - 1. Gmail Artwork
    private var gmailEmblem: some View {
        ZStack {
            // Floating unread pill easter egg
            HStack(spacing: 5) {
                Image(systemName: "sparkles")
                    .font(.caption2.bold())
                Text("Inbox: 0 Unread")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .offset(x: 56, y: -78)

            // Sleek white glass card with multicolor M envelope
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white)
                .frame(width: 136, height: 112)
                .shadow(color: .black.opacity(0.24), radius: 22, y: 12)
                .overlay {
                    ZStack {
                        // Left & right pillars
                        HStack(spacing: 0) {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 14,
                                bottomLeadingRadius: 14,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 4
                            )
                            .fill(GooglePalette.blue)
                            .frame(width: 22, height: 68)

                            Spacer()

                            UnevenRoundedRectangle(
                                topLeadingRadius: 4,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 14,
                                topTrailingRadius: 14
                            )
                            .fill(GooglePalette.green)
                            .frame(width: 22, height: 68)
                        }
                        .frame(width: 96, height: 68)

                        // V-flap in signature Gmail red & gold accent
                        Path { path in
                            path.move(to: CGPoint(x: 20, y: 24))
                            path.addLine(to: CGPoint(x: 68, y: 60))
                            path.addLine(to: CGPoint(x: 116, y: 24))
                        }
                        .stroke(
                            LinearGradient(
                                colors: [GooglePalette.red, GooglePalette.red, GooglePalette.yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 18, lineCap: .round, lineJoin: .round)
                        )
                    }
                }
                .rotationEffect(.degrees(-4))
        }
    }

    // MARK: - 2. YouTube Artwork
    private var youtubeEmblem: some View {
        ZStack {
            // Subtle background cinema wave bars
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.white.opacity(0.14))
                .frame(width: 154, height: 108)
                .rotationEffect(.degrees(7))
                .offset(x: 10, y: 6)

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white)
                .frame(width: 148, height: 104)
                .shadow(color: .black.opacity(0.28), radius: 22, y: 12)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 1.0, green: 0.12, blue: 0.18),
                                        Color(red: 0.84, green: 0.04, blue: 0.12)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(12)

                        Image(systemName: "play.fill")
                            .font(.system(size: 36, weight: .black))
                            .foregroundStyle(.white)
                            .offset(x: 3)
                    }
                }

            HStack(spacing: 5) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 7, height: 7)
                Text("4K · PiP Ready")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .offset(x: -44, y: -74)
        }
    }

    // MARK: - 3. Google Search Artwork
    private var searchEmblem: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 118, height: 118)
                    .shadow(color: .black.opacity(0.22), radius: 20, y: 10)

                Circle()
                    .trim(from: 0.08, to: 0.95)
                    .stroke(
                        AngularGradient(
                            colors: [
                                GooglePalette.blue,
                                GooglePalette.green,
                                GooglePalette.yellow,
                                GooglePalette.red,
                                GooglePalette.blue
                            ],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 68, height: 68)
                    .rotationEffect(.degrees(-20))

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(GooglePalette.blue)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.caption.bold())
                    .foregroundStyle(GooglePalette.blue)
                Text("best coffee near me...")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary.opacity(0.8))
                Image(systemName: "mic.fill")
                    .font(.caption.bold())
                    .foregroundStyle(GooglePalette.red)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(.white.opacity(0.95), in: Capsule())
            .shadow(color: .black.opacity(0.16), radius: 12, y: 6)
        }
    }

    // MARK: - 4. Chrome Artwork
    private var chromeEmblem: some View {
        ZStack {
            // Famous Chrome iOS ":D" 100+ tabs badge
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay {
                        Text(":D")
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                    }
                Text("487 Tabs")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .offset(x: 54, y: -76)

            Circle()
                .fill(.white)
                .frame(width: 128, height: 128)
                .shadow(color: .black.opacity(0.24), radius: 22, y: 12)
                .overlay {
                    ZStack {
                        Circle()
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        GooglePalette.red,
                                        GooglePalette.yellow,
                                        GooglePalette.green,
                                        GooglePalette.red
                                    ],
                                    center: .center
                                ),
                                lineWidth: 26
                            )
                            .frame(width: 78, height: 78)

                        Circle()
                            .fill(.white)
                            .frame(width: 52, height: 52)

                        Circle()
                            .fill(GooglePalette.blue)
                            .frame(width: 40, height: 40)
                    }
                }
        }
    }

    // MARK: - 5. Gemini Artwork
    private var geminiEmblem: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: 146, height: 146)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.35), lineWidth: 1.5)
                }

            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(.white)
                .frame(width: 122, height: 122)
                .shadow(color: .black.opacity(0.24), radius: 22, y: 12)
                .overlay {
                    ZStack {
                        GeminiStarShape()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        GooglePalette.blue,
                                        Color(red: 0.58, green: 0.34, blue: 0.96),
                                        Color(red: 0.92, green: 0.34, blue: 0.58)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 74, height: 74)

                        GeminiStarShape()
                            .fill(GooglePalette.blue.opacity(0.85))
                            .frame(width: 22, height: 22)
                            .offset(x: 28, y: -28)
                    }
                }

            HStack(spacing: 5) {
                Image(systemName: "waveform")
                    .font(.caption2.bold())
                Text("Gemini Live")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .offset(x: -46, y: -78)
        }
    }

    // MARK: - 6. Google Maps Artwork
    private var mapsEmblem: some View {
        ZStack {
            // Stylized street map tile card
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(red: 0.95, green: 0.97, blue: 0.95))
                .frame(width: 138, height: 118)
                .shadow(color: .black.opacity(0.25), radius: 22, y: 12)
                .overlay {
                    ZStack {
                        // Park patch
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(GooglePalette.green.opacity(0.28))
                            .frame(width: 56, height: 48)
                            .offset(x: -28, y: -22)

                        // Water patch
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(GooglePalette.blue.opacity(0.25))
                            .frame(width: 54, height: 44)
                            .offset(x: 30, y: 24)

                        // Navigation route path
                        Path { path in
                            path.move(to: CGPoint(x: 24, y: 94))
                            path.addCurve(
                                to: CGPoint(x: 108, y: 28),
                                control1: CGPoint(x: 42, y: 42),
                                control2: CGPoint(x: 78, y: 74)
                            )
                        }
                        .stroke(
                            GooglePalette.blue,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )

                        // Multicolor Pin
                        VStack(spacing: -4) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                GooglePalette.red,
                                                GooglePalette.yellow,
                                                GooglePalette.green,
                                                GooglePalette.blue
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 46, height: 46)

                                Circle()
                                    .fill(.white)
                                    .frame(width: 18, height: 18)
                            }
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(GooglePalette.green)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                        .offset(x: 12, y: -12)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                }

            HStack(spacing: 5) {
                Image(systemName: "location.fill")
                    .font(.caption2.bold())
                Text("Fastest Route · 4.9★")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial, in: Capsule())
            .offset(x: 38, y: -76)
        }
    }
}

struct GeminiStarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)
        let left = CGPoint(x: rect.minX, y: rect.midY)

        path.move(to: top)
        path.addQuadCurve(to: right, control: center)
        path.addQuadCurve(to: bottom, control: center)
        path.addQuadCurve(to: left, control: center)
        path.addQuadCurve(to: top, control: center)
        path.closeSubpath()
        return path
    }
}
