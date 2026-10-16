import SwiftUI

extension Interaction {
    static let holdToConfirm = Interaction(
        id: "HoldToConfirm",
        title: "Hold to Confirm",
        summary: "A destructive button that only fires after a deliberate hold. A fill sweeps across it and the label inverts color exactly where the fill passes.",
        symbol: "timer",
        tags: ["Buttons", "Gestures", "Haptics", "Destructive actions"],
        keyDetails: [
            "Hold for 1.5 s. The fill sweeps left to right with a linear animation, so progress maps 1:1 to time held.",
            "Letting go early springs the fill back with .spring(duration: 0.35) and does nothing.",
            "Draw the label twice (red on a 12% red tint, white on solid red) and mask the white copy to the fill width, so the text inverts where the fill passes.",
            "Light impact haptic on touch-down, success haptic on completion.",
            "After confirming, show \"Deleted\" with a checkmark, then reset after 2 s.",
            "VoiceOver: one button element whose default action confirms immediately, with no hold required.",
        ]
    ) {
        HoldToConfirm()
    } preview: {
        HoldToConfirmPreview()
    }
}

/// Lets go early once, then holds all the way through.
private struct HoldToConfirmPreview: View {
    @State private var progress: CGFloat = 0
    @State private var isConfirmed = false

    var body: some View {
        HoldToConfirmFace(progress: progress, isConfirmed: isConfirmed)
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(0.8))
                    withAnimation(.linear(duration: 0.6)) { progress = 0.4 }
                    try? await Task.sleep(for: .seconds(0.6))
                    withAnimation(.spring(duration: 0.35)) { progress = 0 }
                    try? await Task.sleep(for: .seconds(0.7))
                    withAnimation(.linear(duration: 1.5)) { progress = 1 }
                    try? await Task.sleep(for: .seconds(1.5))
                    isConfirmed = true
                    try? await Task.sleep(for: .seconds(1.2))
                    withAnimation(.spring(duration: 0.4)) {
                        isConfirmed = false
                        progress = 0
                    }
                }
            }
    }
}
