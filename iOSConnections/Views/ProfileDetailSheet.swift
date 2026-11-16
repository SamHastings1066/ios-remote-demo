import SwiftUI

struct ProfileDetailSheet: View {
    let profile: AppProfile
    var showDeckActions: Bool = false
    var onDecision: ((SwipeDirection) -> Void)? = nil

    @Environment(\.dismiss) private var dismiss
    @State private var likedPrompts: Set<String> = []

    private let gridColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Hero Banner
                    ZStack(alignment: .bottomLeading) {
                        BrandArtworkView(profile: profile)
                            .frame(height: 300)

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.75)],
                            startPoint: .center,
                            endPoint: .bottom
                        )

                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.caption.bold())
                                Text("\(profile.compatibility)% Google Ecosystem Match")
                                    .font(.system(size: 12.5, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.20), in: Capsule())

                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text("\(profile.name), \(profile.age)")
                                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.white)

                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color(red: 0.35, green: 0.72, blue: 1.0))
                            }

                            Text(profile.role)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.92))

                            HStack(spacing: 5) {
                                Image(systemName: "location.fill")
                                    .font(.caption)
                                Text(profile.distance)
                                    .font(.system(size: 13.5, weight: .medium))
                            }
                            .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(22)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .padding(.horizontal, 16)

                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Label("About \(profile.name)", systemImage: "quote.opening")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(profile.accentColor)

                        Text(profile.bio)
                            .font(.system(size: 16, weight: .regular))
                            .lineSpacing(3)
                            .foregroundStyle(.primary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(profile.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 12.5, weight: .semibold, design: .rounded))
                                        .foregroundStyle(profile.accentColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 7)
                                        .background(profile.accentColor.opacity(0.12), in: Capsule())
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(18)
                    .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 16)

                    // Vitals 2x2 Grid
                    VStack(alignment: .leading, spacing: 12) {
                        Text("iOS Vitals")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)

                        LazyVGrid(columns: gridColumns, spacing: 10) {
                            ForEach(profile.vitals) { vital in
                                HStack(spacing: 10) {
                                    Image(systemName: vital.icon)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(profile.accentColor)
                                        .frame(width: 34, height: 34)
                                        .background(profile.accentColor.opacity(0.12), in: Circle())

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(vital.label)
                                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                                            .foregroundStyle(.secondary)
                                        Text(vital.value)
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundStyle(.primary)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.85)
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(12)
                                .background(.white, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // Hinge-Style Prompts
                    VStack(spacing: 12) {
                        ForEach(profile.prompts) { prompt in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(prompt.question)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundStyle(.secondary)

                                Text(prompt.answer)
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundStyle(.primary)
                                    .lineSpacing(2)

                                HStack {
                                    Spacer()
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            if likedPrompts.contains(prompt.id) {
                                                likedPrompts.remove(prompt.id)
                                            } else {
                                                likedPrompts.insert(prompt.id)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: likedPrompts.contains(prompt.id) ? "heart.fill" : "heart")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundStyle(likedPrompts.contains(prompt.id) ? GooglePalette.coral : .secondary)
                                            .frame(width: 40, height: 40)
                                            .background(GooglePalette.canvas, in: Circle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(20)
                            .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer(minLength: showDeckActions ? 88 : 28)
                }
                .padding(.top, 8)
            }
            .background(GooglePalette.canvas)
            .navigationTitle(profile.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .safeAreaInset(edge: .bottom) {
                if showDeckActions, let onDecision {
                    HStack(spacing: 16) {
                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                onDecision(.left)
                            }
                        } label: {
                            Label("Pass", systemImage: "xmark")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(GooglePalette.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.white, in: Capsule())
                                .shadow(color: .black.opacity(0.10), radius: 10, y: 4)
                        }

                        Button {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                                onDecision(.right)
                            }
                        } label: {
                            Label("Connect", systemImage: "heart.fill")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [GooglePalette.coral, GooglePalette.red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    in: Capsule()
                                )
                                .shadow(color: GooglePalette.coral.opacity(0.35), radius: 10, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                }
            }
        }
    }
}
