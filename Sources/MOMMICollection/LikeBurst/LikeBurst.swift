import SwiftUI

/// A like button that pops when you tap it.
///
/// - Like: the heart fills red and pops (scale 1 → 1.35 → 1, the return on a bouncy spring)
///   while a ring of eight dots bursts outward and fades.
/// - Unlike: the heart empties instantly, with no pop or burst.
/// - Haptic: light impact on like only.
/// - Reduce Motion: no pop or burst; the heart only changes fill.
struct LikeBurst: View {
    @State private var isLiked = false

    var body: some View {
        Button {
            isLiked.toggle()
        } label: {
            LikeBurstFace(isLiked: isLiked)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .light), trigger: isLiked) { _, liked in liked }
        .accessibilityLabel("Like")
        .accessibilityAddTraits(isLiked ? .isSelected : [])
    }
}

/// The heart and its burst for a given liked state. Becoming liked plays the pop.
struct LikeBurstFace: View {
    var isLiked: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pops = 0

    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(index.isMultiple(of: 2) ? Color.red : Color.orange)
                    .frame(width: 10, height: 10)
                    .keyframeAnimator(initialValue: BurstDot(), trigger: pops) { dot, value in
                        dot
                            .scaleEffect(value.scale)
                            .opacity(value.opacity)
                            .offset(y: -value.distance)
                    } keyframes: { _ in
                        KeyframeTrack(\.distance) { CubicKeyframe(78, duration: 0.5) }
                        KeyframeTrack(\.opacity) {
                            LinearKeyframe(1, duration: 0.05)
                            LinearKeyframe(0, duration: 0.45)
                        }
                        KeyframeTrack(\.scale) { LinearKeyframe(0.3, duration: 0.5) }
                    }
                    .rotationEffect(.degrees(Double(index) * 45))
            }

            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 72, weight: .medium))
                .foregroundStyle(isLiked ? Color.red : Color.secondary)
                .keyframeAnimator(initialValue: 1.0, trigger: pops) { heart, scale in
                    heart.scaleEffect(scale)
                } keyframes: { _ in
                    SpringKeyframe(1.35, duration: 0.12)
                    SpringKeyframe(1.0, duration: 0.5, spring: .bouncy)
                }
        }
        .frame(width: 200, height: 200)
        .onChange(of: isLiked) { _, liked in
            if liked && !reduceMotion { pops += 1 }
        }
    }
}

private struct BurstDot {
    var distance: CGFloat = 30
    var opacity: Double = 0
    var scale: CGFloat = 1
}
