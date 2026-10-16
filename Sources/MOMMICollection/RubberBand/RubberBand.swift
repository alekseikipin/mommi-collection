import SwiftUI

/// A blob you can pull. It follows your finger with growing resistance, stretches along the
/// pull, and snaps home on a bouncy spring when you let go.
///
/// - Drag: rubber-band resistance on each axis, `limit * (1 - 1 / (distance / limit * 0.55 + 1))`
///   with a 120 pt limit. It's the same curve iOS uses for overscroll.
/// - Stretch: up to 1.3× along the pull and squashed to 0.82× across it, proportional to how far it has moved.
/// - Release: springs home with `.spring(response: 0.45, dampingFraction: 0.45)`, overshooting
///   and briefly stretching the other way.
/// - Haptic: soft impact on release if it was pulled more than 40 pt.
/// - Reduce Motion: no stretch; it still follows your finger and returns.
struct RubberBand: View {
    @State private var offset: CGSize = .zero
    @State private var releases = 0

    var body: some View {
        RubberBandFace(offset: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = Self.resisted(value.translation)
                    }
                    .onEnded { _ in
                        if hypot(offset.width, offset.height) > 40 { releases += 1 }
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.45)) {
                            offset = .zero
                        }
                    }
            )
            .sensoryFeedback(.impact(flexibility: .soft), trigger: releases)
            .accessibilityElement()
            .accessibilityLabel("Stretchy blob")
            .accessibilityHint("Drag to pull it")
    }

    /// Applies rubber-band resistance to a raw drag translation.
    static func resisted(_ translation: CGSize) -> CGSize {
        let limit: CGFloat = 120
        func resist(_ value: CGFloat) -> CGFloat {
            let sign: CGFloat = value < 0 ? -1 : 1
            return sign * limit * (1 - 1 / (abs(value) / limit * 0.55 + 1))
        }
        return CGSize(width: resist(translation.width), height: resist(translation.height))
    }
}

/// The blob for a given offset from its resting point. Recomputed every animation frame,
/// so the stretch follows the spring through its overshoot.
struct RubberBandFace: View, Animatable {
    var offset: CGSize

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    nonisolated var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(offset.width, offset.height) }
        set { offset = CGSize(width: newValue.first, height: newValue.second) }
    }

    var body: some View {
        let distance = hypot(offset.width, offset.height)
        let stretch = reduceMotion ? 0 : min(distance / 120, 1)
        let direction = Angle(radians: atan2(offset.height, offset.width))

        Circle()
            .fill(RadialGradient(colors: [.pink, .orange], center: .center, startRadius: 0, endRadius: 80))
            .frame(width: 130, height: 130)
            .scaleEffect(x: 1 + stretch * 0.3, y: 1 - stretch * 0.18)
            .rotationEffect(direction)
            .shadow(color: .orange.opacity(0.4), radius: 24, y: 12)
            .offset(offset)
    }
}
