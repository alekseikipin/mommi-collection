import SwiftUI

extension Interaction {
    static let rubberBand = Interaction(
        id: "RubberBand",
        title: "Rubber Band",
        summary: "A blob you can pull. It resists more the further you drag, stretches along the pull, and snaps home with a wobble.",
        symbol: "circle.dotted.and.circle",
        tags: ["Gestures", "Springs", "Physics"],
        keyDetails: [
            "Resist the drag on each axis with limit × (1 − 1 / (distance / limit × 0.55 + 1)) and a 120 pt limit, the same curve iOS uses for overscroll.",
            "Stretch along the pull direction: scale up to 1.3× along it and 0.82× across it, proportional to distance / 120 (capped at 1).",
            "Recompute the stretch from the animated offset on every frame (make the view Animatable), so it stretches the other way during the spring's overshoot.",
            "On release, spring home with .spring(response: 0.45, dampingFraction: 0.45).",
            "Soft impact haptic on release, only if it was pulled more than 40 pt.",
            "Reduce Motion: no stretch; it still follows the finger and springs back.",
        ]
    ) {
        RubberBand()
    } preview: {
        RubberBandPreview()
    }
}

/// Pulls the blob in a few directions and lets it snap back.
private struct RubberBandPreview: View {
    @State private var offset: CGSize = .zero

    private let pulls: [CGSize] = [
        CGSize(width: -60, height: -220),
        CGSize(width: 240, height: 40),
        CGSize(width: -120, height: 200),
    ]

    var body: some View {
        RubberBandFace(offset: offset)
            .task {
                while !Task.isCancelled {
                    for pull in pulls {
                        try? await Task.sleep(for: .seconds(0.7))
                        withAnimation(.easeOut(duration: 0.5)) { offset = RubberBand.resisted(pull) }
                        try? await Task.sleep(for: .seconds(0.6))
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.45)) { offset = .zero }
                    }
                }
            }
    }
}
