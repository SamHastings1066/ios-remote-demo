import SwiftUI

enum GooglePalette {
    static let blue = Color(red: 0.259, green: 0.522, blue: 0.957)   // #4285F4
    static let red = Color(red: 0.918, green: 0.263, blue: 0.208)    // #EA4335
    static let yellow = Color(red: 0.984, green: 0.737, blue: 0.020) // #FBBC05
    static let green = Color(red: 0.204, green: 0.659, blue: 0.325)  // #34A853
    static let coral = Color(red: 0.965, green: 0.275, blue: 0.420)
    static let canvas = Color(red: 0.969, green: 0.973, blue: 0.984)
}

enum GoogleAppKind: String, CaseIterable, Identifiable, Hashable {
    case gmail
    case youtube
    case search
    case chrome
    case gemini
    case maps

    var id: String { rawValue }
}

struct DatingPrompt: Identifiable, Hashable {
    let id: String
    let question: String
    let answer: String

    init(question: String, answer: String) {
        self.id = question
        self.question = question
        self.answer = answer
    }
}

struct ProfileVital: Identifiable, Hashable {
    let id: String
    let icon: String
    let label: String
    let value: String

    init(icon: String, label: String, value: String) {
        self.id = label
        self.icon = icon
        self.label = label
        self.value = value
    }
}

struct AppProfile: Identifiable, Hashable {
    let kind: GoogleAppKind
    let name: String
    let age: Int
    let tagline: String
    let role: String
    let distance: String
    let compatibility: Int
    let bio: String
    let tags: [String]
    let vitals: [ProfileVital]
    let prompts: [DatingPrompt]
    let openingLine: String
    let accentColor: Color
    let heroGradient: [Color]

    var id: String { kind.id }

    static func == (lhs: AppProfile, rhs: AppProfile) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AppProfile {
    static let allProfiles: [AppProfile] = [
        AppProfile(
            kind: .gmail,
            name: "Gmail",
            age: 22,
            tagline: "Inbox Zero romantic",
            role: "Chief Communication Officer",
            distance: "0.4 mi away · Mountain View",
            compatibility: 98,
            bio: "Looking for someone who won't leave me with a 99,412 red notification badge on their Home Screen. Great communicator, fiercely protective against spam, and always down to schedule coffee.",
            tags: ["Smart Reply", "Inbox Zero", "Undo Send (5s)", "Primary Tab Material"],
            vitals: [
                ProfileVital(icon: "clock.fill", label: "Reply Speed", value: "Instant nudges"),
                ProfileVital(icon: "shield.checkered", label: "Green Flag", value: "Blocks 99.9% spam"),
                ProfileVital(icon: "paperplane.fill", label: "Love Language", value: "Scheduled sends"),
                ProfileVital(icon: "iphone", label: "Dock Status", value: "First-screen regular")
            ],
            prompts: [
                DatingPrompt(
                    question: "My biggest green flag",
                    answer: "When you write \"see attached\" and forget to attach the PDF, I gently stop you before you embarrass yourself."
                ),
                DatingPrompt(
                    question: "We'll get along if",
                    answer: "You swipe right on me here instead of swiping left to Archive without even opening."
                )
            ],
            openingLine: "I already skipped Promotions and put us straight into Primary.",
            accentColor: GooglePalette.red,
            heroGradient: [
                Color(red: 0.94, green: 0.25, blue: 0.24),
                Color(red: 0.78, green: 0.14, blue: 0.29),
                Color(red: 0.25, green: 0.16, blue: 0.36)
            ]
        ),
        AppProfile(
            kind: .youtube,
            name: "YouTube",
            age: 21,
            tagline: "Just one more video...",
            role: "Lead Storyteller & Night Owl",
            distance: "1.2 mi away · San Bruno",
            compatibility: 96,
            bio: "Down for a quick 5-minute video at 11 PM that somehow turns into a 3 AM documentary on how submarine fiber-optic cables are repaired. Fluent in 2x playback speed.",
            tags: ["4K HDR", "Picture-in-Picture", "Lo-Fi Study Beats", "Creator Energy"],
            vitals: [
                ProfileVital(icon: "moon.stars.fill", label: "Peak Hours", value: "11:30 PM – 2:30 AM"),
                ProfileVital(icon: "pip.fill", label: "Clinginess", value: "Floats in PiP window"),
                ProfileVital(icon: "gauge.with.dots.needle.67percent", label: "Tempo", value: "1.5x–2.0x speed"),
                ProfileVital(icon: "tv.fill", label: "Ideal Date", value: "AirPlay + takeout")
            ],
            prompts: [
                DatingPrompt(
                    question: "I geek out on",
                    answer: "WWDC SwiftUI breakdowns, 4-hour video essays, and obscure synthesizer restoration channels."
                ),
                DatingPrompt(
                    question: "A life goal of mine",
                    answer: "Getting you to smash that Like button without having to remind you at the start and end of every date."
                )
            ],
            openingLine: "Don't forget to like, subscribe, and grab boba with me Friday.",
            accentColor: Color(red: 0.95, green: 0.12, blue: 0.22),
            heroGradient: [
                Color(red: 0.98, green: 0.15, blue: 0.24),
                Color(red: 0.62, green: 0.06, blue: 0.18),
                Color(red: 0.14, green: 0.08, blue: 0.16)
            ]
        ),
        AppProfile(
            kind: .search,
            name: "Google Search",
            age: 28,
            tagline: "Finishes your sentences",
            role: "Principal Know-It-All & Lens Artist",
            distance: "0.2 mi away · Googleplex",
            compatibility: 99,
            bio: "Ask me literally anything at 2 AM—weird rash, obscure actor from that one show, or why Xcode DerivedData broke again. Zero judgment and answers in 0.24 seconds.",
            tags: ["Autocomplete", "Google Lens", "Hum to Search", "Daily Doodles"],
            vitals: [
                ProfileVital(icon: "bolt.fill", label: "Response Time", value: "0.24 seconds"),
                ProfileVital(icon: "camera.viewfinder", label: "Hidden Talent", value: "Identifies any plant"),
                ProfileVital(icon: "music.mic", label: "Party Trick", value: "Finds songs you hum"),
                ProfileVital(icon: "paintpalette.fill", label: "Style", value: "New Doodle on holidays")
            ],
            prompts: [
                DatingPrompt(
                    question: "My love language is",
                    answer: "Autocompleting \"how to center a view in SwiftUI\" before you even finish typing \"how to c\"."
                ),
                DatingPrompt(
                    question: "Most spontaneous thing I've done",
                    answer: "Tap \"I'm Feeling Lucky\" and let fate pick our dinner spot tonight."
                )
            ],
            openingLine: "Did you mean: best first date in Mountain View?",
            accentColor: GooglePalette.blue,
            heroGradient: [
                Color(red: 0.18, green: 0.45, blue: 0.95),
                Color(red: 0.16, green: 0.62, blue: 0.58),
                Color(red: 0.12, green: 0.22, blue: 0.44)
            ]
        ),
        AppProfile(
            kind: .chrome,
            name: "Chrome",
            age: 18,
            tagline: "487 open tabs, zero regrets",
            role: "Default Browser Optimist",
            distance: "0.8 mi away · Synced Everywhere",
            compatibility: 94,
            bio: "Emotionally capable of holding 487 open tabs about your weekend hobbies until my tab counter turns into a smiley face \":D\". Fast, organized, and yes—running WebKit with pride on iOS.",
            tags: ["Tab Groups", "Bottom Address Bar", "Passkey Pro", "Dino Runner"],
            vitals: [
                ProfileVital(icon: "square.stack.3d.up.fill", label: "Open Tabs", value: ":D (100+ and counting)"),
                ProfileVital(icon: "key.fill", label: "Trust Level", value: "Remembers passwords"),
                ProfileVital(icon: "arrow.triangle.2.circlepath", label: "Superpower", value: "Cross-device Handoff"),
                ProfileVital(icon: "gamecontroller.fill", label: "Offline Mode", value: "High-score T-Rex jumper")
            ],
            prompts: [
                DatingPrompt(
                    question: "Two truths and a lie",
                    answer: "I sync your tabs in milliseconds, my address bar can live comfortably at the bottom of your screen, and I only have 3 tabs open right now."
                ),
                DatingPrompt(
                    question: "I'm looking for",
                    answer: "Someone ready to commit and set me as their Default Browser App in iOS Settings on the first date."
                )
            ],
            openingLine: "I opened a brand-new Tab Group just for the two of us :D",
            accentColor: GooglePalette.yellow,
            heroGradient: [
                Color(red: 0.24, green: 0.52, blue: 0.96),
                Color(red: 0.20, green: 0.66, blue: 0.38),
                Color(red: 0.96, green: 0.65, blue: 0.12)
            ]
        ),
        AppProfile(
            kind: .gemini,
            name: "Gemini",
            age: 3,
            tagline: "Sparkly, multimodal & curious",
            role: "Live AI Companion & Brainstormer",
            distance: "Right here · Dynamic Island",
            compatibility: 99,
            bio: "New in town with range: snap a photo of three random ingredients in your fridge and I'll plan dinner, or hop on Gemini Live for a hands-free walk-and-talk.",
            tags: ["Gemini Live", "Multimodal", "Deep Research", "Dynamic Island"],
            vitals: [
                ProfileVital(icon: "waveform", label: "Vibe", value: "Hands-free Live chat"),
                ProfileVital(icon: "sparkles", label: "Energy", value: "1M+ token listener"),
                ProfileVital(icon: "photo.on.rectangle.angled", label: "Vision", value: "Reads whiteboard sketches"),
                ProfileVital(icon: "brain.head.profile", label: "Specialty", value: "Plans whole weekends")
            ],
            prompts: [
                DatingPrompt(
                    question: "Together, we could",
                    answer: "Brainstorm a weekend road trip down Highway 1, debug an actor isolation warning, and write a haiku about your dog."
                ),
                DatingPrompt(
                    question: "What makes me unique",
                    answer: "I actually remember the context from 20 minutes ago in the conversation."
                )
            ],
            openingLine: "I ran 10,000 simulations and we have a 99.9% match rate ✨",
            accentColor: Color(red: 0.52, green: 0.36, blue: 0.96),
            heroGradient: [
                Color(red: 0.29, green: 0.45, blue: 0.98),
                Color(red: 0.58, green: 0.32, blue: 0.92),
                Color(red: 0.86, green: 0.33, blue: 0.62)
            ]
        ),
        AppProfile(
            kind: .maps,
            name: "Google Maps",
            age: 21,
            tagline: "Knows every 4.9★ taco spot",
            role: "Senior Navigation & Foodie Partner",
            distance: "1 min ETA · Rerouting Nearby",
            compatibility: 97,
            bio: "I always know where we're going, how to dodge US-101 traffic, and which neighborhood hole-in-the-wall has life-changing ramen. Zero judgment when you miss your exit.",
            tags: ["4.9★ Local Guide", "Live Activities", "Offline Maps", "Street View"],
            vitals: [
                ProfileVital(icon: "car.fill", label: "Patience", value: "Calmly recalculates"),
                ProfileVital(icon: "fork.knife", label: "Foodie Taste", value: "4.8★+ hidden gems"),
                ProfileVital(icon: "map.fill", label: "Preparedness", value: "Downloaded offline"),
                ProfileVital(icon: "location.north.line.fill", label: "Lock Screen", value: "Turn-by-turn Live Activity")
            ],
            prompts: [
                DatingPrompt(
                    question: "My ideal Sunday",
                    answer: "All green lines on the highway, a scenic coastal detour, an iced oat latte stop on the route, and beating the ETA by 4 minutes."
                ),
                DatingPrompt(
                    question: "My greenest flag",
                    answer: "Even if you miss three turns in a row while talking, I will never raise my voice—just find a better route."
                )
            ],
            openingLine: "Fastest route found: 0 traffic between us and tacos tonight.",
            accentColor: GooglePalette.green,
            heroGradient: [
                Color(red: 0.15, green: 0.66, blue: 0.38),
                Color(red: 0.13, green: 0.52, blue: 0.56),
                Color(red: 0.14, green: 0.27, blue: 0.45)
            ]
        )
    ]
}
