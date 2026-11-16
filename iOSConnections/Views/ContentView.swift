import SwiftUI

enum BrowseMode: String, CaseIterable, Identifiable {
    case deck = "Discover"
    case directory = "All 6 Apps"

    var id: String { rawValue }
}

struct ContentView: View {
    @State private var mode: BrowseMode = .deck
    @State private var currentIndex: Int = 0
    @State private var matchedProfiles: [AppProfile] = []
    @State private var selectedProfile: AppProfile? = nil
    @State private var openedFromDeck: Bool = false
    @State private var latestMatchBanner: AppProfile? = nil
    @State private var feedbackTrigger: Int = 0

    private let profiles = AppProfile.allProfiles

    private let directoryColumns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack(alignment: .top) {
            GooglePalette.canvas
                .ignoresSafeArea()

            VStack(spacing: 12) {
                headerBar

                modePicker

                if mode == .deck {
                    deckExperience
                } else {
                    directoryExperience
                }
            }
            .padding(.top, 6)

            if let match = latestMatchBanner {
                matchToast(for: match)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: feedbackTrigger)
        .sheet(item: $selectedProfile) { profile in
            ProfileDetailSheet(
                profile: profile,
                showDeckActions: openedFromDeck && currentProfile?.id == profile.id,
                onDecision: { direction in
                    handleSwipe(direction, for: profile)
                }
            )
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Top Header
    private var headerBar: some View {
        HStack(spacing: 10) {
            // 4-color Google spark cluster + heart
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [GooglePalette.coral, Color(red: 0.58, green: 0.24, blue: 0.88)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)

                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 5) {
                    Text("iOS Connections")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(.primary)

                    googleFourDots
                }
                Text("Google iOS Singles Near You")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 5) {
                Image(systemName: "heart.fill")
                    .font(.caption.bold())
                    .foregroundStyle(GooglePalette.coral)
                Text("\(matchedProfiles.count)/\(profiles.count)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(.white, in: Capsule())
            .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
        }
        .padding(.horizontal, 18)
    }

    private var googleFourDots: some View {
        HStack(spacing: 3) {
            Circle().fill(GooglePalette.blue).frame(width: 6, height: 6)
            Circle().fill(GooglePalette.red).frame(width: 6, height: 6)
            Circle().fill(GooglePalette.yellow).frame(width: 6, height: 6)
            Circle().fill(GooglePalette.green).frame(width: 6, height: 6)
        }
        .padding(.leading, 2)
    }

    private var modePicker: some View {
        HStack(spacing: 6) {
            ForEach(BrowseMode.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.8)) {
                        mode = tab
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: tab == .deck ? "rectangle.stack.fill" : "square.grid.2x2.fill")
                            .font(.system(size: 12.5, weight: .bold))
                        Text(tab.rawValue)
                            .font(.system(size: 13.5, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(mode == tab ? .white : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 9)
                    .background {
                        if mode == tab {
                            Capsule()
                                .fill(Color.primary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(.white, in: Capsule())
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        .padding(.horizontal, 18)
    }

    // MARK: - Swipe Deck Experience
    private var currentProfile: AppProfile? {
        guard currentIndex < profiles.count else { return nil }
        return profiles[currentIndex]
    }

    private var deckExperience: some View {
        VStack(spacing: 14) {
            ZStack {
                if currentIndex >= profiles.count {
                    endOfDeckCard
                } else {
                    ForEach(Array(profiles.enumerated().reversed()), id: \.element.id) { index, profile in
                        if index >= currentIndex && index <= currentIndex + 2 {
                            let relativeDepth = index - currentIndex
                            SwipeCardView(
                                profile: profile,
                                isTopCard: relativeDepth == 0,
                                onSwipe: { direction in
                                    handleSwipe(direction, for: profile)
                                },
                                onOpenDetails: {
                                    openedFromDeck = true
                                    selectedProfile = profile
                                }
                            )
                            .scaleEffect(1.0 - CGFloat(relativeDepth) * 0.045)
                            .offset(y: CGFloat(relativeDepth) * 11)
                            .allowsHitTesting(relativeDepth == 0)
                            .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let topProfile = currentProfile {
                deckControlBar(for: topProfile)
                    .padding(.bottom, 8)
            }
        }
    }

    private func deckControlBar(for profile: AppProfile) -> some View {
        HStack(spacing: 20) {
            // Rewind previous card
            Button {
                guard currentIndex > 0 else { return }
                withAnimation(.spring(response: 0.35, dampingFraction: 0.78)) {
                    currentIndex -= 1
                    let restored = profiles[currentIndex]
                    matchedProfiles.removeAll { $0.id == restored.id }
                }
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(currentIndex > 0 ? GooglePalette.yellow : .secondary.opacity(0.4))
                    .frame(width: 48, height: 48)
                    .background(.white, in: Circle())
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            }
            .disabled(currentIndex == 0)

            // Pass (Swipe Left)
            Button {
                handleSwipe(.left, for: profile)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .black))
                    .foregroundStyle(GooglePalette.red)
                    .frame(width: 64, height: 64)
                    .background(.white, in: Circle())
                    .shadow(color: .black.opacity(0.10), radius: 12, y: 5)
            }

            // View Full Profile
            Button {
                openedFromDeck = true
                selectedProfile = profile
            } label: {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(GooglePalette.blue)
                    .frame(width: 48, height: 48)
                    .background(.white, in: Circle())
                    .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
            }

            // Connect (Swipe Right)
            Button {
                handleSwipe(.right, for: profile)
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        LinearGradient(
                            colors: [GooglePalette.coral, GooglePalette.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: Circle()
                    )
                    .shadow(color: GooglePalette.coral.opacity(0.38), radius: 12, y: 5)
            }
        }
    }

    private var endOfDeckCard: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(GooglePalette.coral.opacity(0.12))
                    .frame(width: 88, height: 88)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(GooglePalette.coral)
            }

            Text("You've Met All 6 Google iOS Apps!")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)

            Text(
                matchedProfiles.isEmpty
                    ? "Playing hard to get? Reset the deck to give Gmail, YouTube, Search, Chrome, Gemini, and Maps another shot."
                    : "You connected with \(matchedProfiles.map(\.name).joined(separator: ", "))."
            )
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 18)

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.78)) {
                        currentIndex = 0
                        matchedProfiles.removeAll()
                    }
                } label: {
                    Label("Swipe Again", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 13)
                        .background(
                            LinearGradient(
                                colors: [GooglePalette.blue, Color(red: 0.48, green: 0.30, blue: 0.92)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: Capsule()
                        )
                }

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        mode = .directory
                    }
                } label: {
                    Text("Browse All 6")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 13)
                        .background(GooglePalette.canvas, in: Capsule())
                }
            }
            .padding(.top, 4)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 18, y: 8)
    }

    // MARK: - All 6 Apps Directory Grid
    private var directoryExperience: some View {
        ScrollView {
            LazyVGrid(columns: directoryColumns, spacing: 14) {
                ForEach(profiles) { profile in
                    Button {
                        openedFromDeck = false
                        selectedProfile = profile
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .topTrailing) {
                                BrandArtworkView(profile: profile, compact: true)
                                    .frame(height: 142)

                                if matchedProfiles.contains(profile) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundStyle(.white)
                                        .padding(7)
                                        .background(GooglePalette.coral, in: Circle())
                                        .padding(10)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text("\(profile.name), \(profile.age)")
                                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)

                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 13))
                                        .foregroundStyle(GooglePalette.blue)
                                }

                                Text(profile.tagline)
                                    .font(.system(size: 12.5, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)

                                Text("\(profile.compatibility)% Match")
                                    .font(.system(size: 11.5, weight: .bold, design: .rounded))
                                    .foregroundStyle(profile.accentColor)
                                    .padding(.top, 2)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .shadow(color: .black.opacity(0.07), radius: 10, y: 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Match Banner & Logic
    private func handleSwipe(_ direction: SwipeDirection, for profile: AppProfile) {
        feedbackTrigger += 1
        withAnimation(.spring(response: 0.36, dampingFraction: 0.8)) {
            if direction == .right && !matchedProfiles.contains(profile) {
                matchedProfiles.append(profile)
                showMatchToast(for: profile)
            }
            if currentIndex < profiles.count {
                currentIndex += 1
            }
        }
    }

    private func showMatchToast(for profile: AppProfile) {
        withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
            latestMatchBanner = profile
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            if latestMatchBanner?.id == profile.id {
                withAnimation(.easeOut(duration: 0.25)) {
                    latestMatchBanner = nil
                }
            }
        }
    }

    private func matchToast(for profile: AppProfile) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 30))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 2) {
                Text("Connected with \(profile.name)!")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)

                Text("\"\(profile.openingLine)\"")
                    .font(.system(size: 12.5, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [GooglePalette.coral, Color(red: 0.84, green: 0.18, blue: 0.36)],
                startPoint: .leading,
                endPoint: .trailing
            ),
            in: RoundedRectangle(cornerRadius: 20, style: .continuous)
        )
        .shadow(color: GooglePalette.coral.opacity(0.4), radius: 14, y: 6)
        .onTapGesture {
            withAnimation {
                latestMatchBanner = nil
            }
        }
    }
}
