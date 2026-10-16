import SwiftUI

/// A card that sinks under your finger and springs back when you let go.
///
/// - Press: scales to 96% and its shadow tightens, on a snappy spring.
/// - Release: springs back with a little overshoot and a soft haptic tap.
/// - Reduce Motion: no scale; the card only dims while pressed.
///
/// The behavior lives in ``PressableCardStyle``, so it works on any button.
struct PressableCard: View {
    var body: some View {
        Button {} label: {
            PressableCardFace()
        }
        .buttonStyle(PressableCardStyle())
    }
}

/// The card's artwork. Swap in your own content.
struct PressableCardFace: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "sparkles")
                .font(.title)
            Spacer()
            Text("Press me")
                .font(.title2.bold())
            Text("Feel it sink, then spring back.")
                .font(.subheadline)
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(width: 280, height: 200, alignment: .leading)
        .background(
            LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: .rect(cornerRadius: 28)
        )
    }
}

struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .pressEffect(isPressed: configuration.isPressed)
            .sensoryFeedback(.impact(flexibility: .soft), trigger: configuration.isPressed) { wasPressed, isPressed in
                wasPressed && !isPressed
            }
    }
}

extension View {
    /// The sink-and-spring look for a given pressed state.
    func pressEffect(isPressed: Bool) -> some View {
        modifier(PressEffect(isPressed: isPressed))
    }
}

private struct PressEffect: ViewModifier {
    let isPressed: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed && !reduceMotion ? 0.96 : 1)
            .opacity(isPressed && reduceMotion ? 0.8 : 1)
            .shadow(color: .black.opacity(0.25), radius: isPressed ? 6 : 20, y: isPressed ? 3 : 12)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}
