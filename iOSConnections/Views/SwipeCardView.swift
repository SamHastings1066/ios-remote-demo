import SwiftUI

enum SwipeDirection {
    case left
    case right
}

struct SwipeCardView: View {
    let profile: AppProfile
    let isTopCard: Bool
    let onSwipe: (SwipeDirection) -> Void
    let onOpenDetails: () -> Void

    @State private var dragOffset: CGSize = .zero

    private let swipeThreshold: CGFloat = 105

    var body: some View {
        GeometryReader { geo in
            let heroHeight = max(geo.size.height * 0.56, 240)

            VStack(spacing: 0) {
                // Upper Hero Section
                ZStack(alignment: .bottomLeading) {
                    BrandArtworkView(profile: profile)
                        .frame(height: heroHeight)

                    // Bottom readability gradient
                    LinearGradient(
                        colors: [
                            .clear,
                            .black.opacity(0.28),
                            .black.opacity(0.78)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: heroHeight * 0.58)

                    // Top row badges
                    VStack {
                        HStack {
                            HStack(spacing: 5) {
                                Image(systemName: "sparkles")
                                    .font(.caption2.bold())
                                Text("\(profile.compatibility)% Match")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(.black.opacity(0.34), in: Capsule())

                            Spacer()

                            Button(action: onOpenDetails) {
                                HStack(spacing: 4) {
                                    Text("Profile")
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(.black.opacity(0.34), in: Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(16)

                        Spacer()
                    }
                    .frame(height: heroHeight)

                    // Swipe Decision Stamps
                    swipeStampOverlay
                        .frame(height: heroHeight)

                    // Name, Age, Role & Distance
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .firstTextBaseline, spacing: 7) {
                            Text("\(profile.name), \(profile.age)")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)

                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(red: 0.35, green: 0.72, blue: 1.0))
                        }

                        Text(profile.role)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.92))

                        HStack(spacing: 5) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 11))
                            Text(profile.distance)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 18)
                }

                // Lower Bio + Prompt Preview Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(profile.bio)
                        .font(.system(size: 14.5, weight: .regular))
                        .foregroundStyle(Color.primary.opacity(0.86))
                        .lineSpacing(2)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    // Scrollable Tag Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 7) {
                            ForEach(profile.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .foregroundStyle(profile.accentColor)
                                    .padding(.horizontal, 11)
                                    .padding(.vertical, 6)
                                    .background(profile.accentColor.opacity(0.11), in: Capsule())
                            }
                        }
                    }

                    if let featuredPrompt = profile.prompts.first {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(featuredPrompt.question.uppercased())
                                .font(.system(size: 10.5, weight: .bold, design: .rounded))
                                .tracking(0.6)
                                .foregroundStyle(.secondary)

                            Text(featuredPrompt.answer)
                                .font(.system(size: 13.5, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color(red: 0.965, green: 0.969, blue: 0.980), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 18)
                .padding(.top, 15)
                .padding(.bottom, 14)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(.black.opacity(0.06), lineWidth: 1)
            }
            .shadow(color: .black.opacity(isTopCard ? 0.14 : 0.06), radius: 22, y: 12)
            .contentShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .onTapGesture {
                if isTopCard {
                    onOpenDetails()
                }
            }
            .offset(x: dragOffset.width, y: dragOffset.height * 0.28)
            .rotationEffect(.degrees(Double(dragOffset.width / 18)))
            .gesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in
                        guard isTopCard else { return }
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        guard isTopCard else { return }
                        if value.translation.width > swipeThreshold {
                            completeSwipe(.right)
                        } else if value.translation.width < -swipeThreshold {
                            completeSwipe(.left)
                        } else {
                            withAnimation(.spring(response: 0.36, dampingFraction: 0.74)) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
        }
    }

    private var swipeStampOverlay: some View {
        ZStack {
            if dragOffset.width > 20 {
                HStack {
                    stampBadge(
                        text: "CONNECT",
                        icon: "heart.fill",
                        color: GooglePalette.green,
                        angle: -14
                    )
                    .opacity(min(Double(dragOffset.width / 95), 1.0))
                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.top, 58)
                .frame(maxHeight: .infinity, alignment: .top)
            } else if dragOffset.width < -20 {
                HStack {
                    Spacer()
                    stampBadge(
                        text: "PASS",
                        icon: "xmark",
                        color: GooglePalette.red,
                        angle: 14
                    )
                    .opacity(min(Double(-dragOffset.width / 95), 1.0))
                }
                .padding(.horizontal, 22)
                .padding(.top, 58)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .allowsHitTesting(false)
    }

    private func stampBadge(text: String, icon: String, color: Color, angle: Double) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .black))
            Text(text)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .tracking(1.2)
        }
        .foregroundStyle(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(color, lineWidth: 3.5)
        }
        .rotationEffect(.degrees(angle))
        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
    }

    private func completeSwipe(_ direction: SwipeDirection) {
        let horizontalExit: CGFloat = direction == .right ? 520 : -520
        withAnimation(.easeOut(duration: 0.24)) {
            dragOffset = CGSize(width: horizontalExit, height: 30)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            dragOffset = .zero
            onSwipe(direction)
        }
    }
}
