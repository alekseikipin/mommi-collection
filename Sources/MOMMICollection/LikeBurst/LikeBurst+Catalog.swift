import SwiftUI

extension Interaction {
    static let likeBurst = Interaction(
        id: "LikeBurst",
        title: "Like Burst",
        summary: "A heart that pops when you like something, throwing a ring of confetti dots outward.",
        symbol: "heart",
        tags: ["Buttons", "Keyframes", "Haptics"],
        keyDetails: [
            "On like: the heart fills red and scales 1 → 1.35 in 0.12 s, then back to 1 on a bouncy spring over 0.5 s.",
            "At the same moment, eight 10 pt dots (alternating red and orange, 45° apart) travel from 30 pt to 78 pt out, flash in over 0.05 s, fade over 0.45 s, and shrink to 30%.",
            "Unlike is instant: the heart empties with no pop and no burst.",
            "Light impact haptic on like only.",
            "Reduce Motion: no pop or burst, only the fill change.",
            "VoiceOver: a button labeled \"Like\" with the selected trait while liked.",
        ]
    ) {
        LikeBurst()
    } preview: {
        LikeBurstPreview()
    }
}

/// Likes, waits, unlikes, repeats.
private struct LikeBurstPreview: View {
    @State private var isLiked = false

    var body: some View {
        LikeBurstFace(isLiked: isLiked)
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(0.8))
                    isLiked = true
                    try? await Task.sleep(for: .seconds(1.6))
                    isLiked = false
                }
            }
    }
}
