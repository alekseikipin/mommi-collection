import SwiftUI

extension Interaction {
    static let pressableCard = Interaction(
        id: "PressableCard",
        title: "Pressable Card",
        summary: "A card that sinks under your finger and springs back with a soft haptic tap when you let go.",
        symbol: "hand.tap",
        tags: ["Buttons", "Springs", "Haptics"],
        keyDetails: [
            "Implement it as a reusable button style so it works on any button, not just this card.",
            "Pressed: scale 0.96, shadow radius 20 → 6 and y-offset 12 → 3.",
            "Animate both directions with .spring(response: 0.3, dampingFraction: 0.6).",
            "Soft impact haptic on release only, not on touch-down.",
            "Reduce Motion: skip the scale and dim to 80% opacity instead.",
        ]
    ) {
        PressableCard()
    } preview: {
        PressableCardPreview()
    }
}

/// Presses and releases the card on a loop.
private struct PressableCardPreview: View {
    @State private var isPressed = false

    var body: some View {
        PressableCardFace()
            .pressEffect(isPressed: isPressed)
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(1.2))
                    isPressed = true
                    try? await Task.sleep(for: .seconds(0.45))
                    isPressed = false
                }
            }
    }
}
