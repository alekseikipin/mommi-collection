import SwiftUI

/// A destructive button that only fires after a deliberate 1.5-second hold.
///
/// - Hold: a red fill sweeps left to right at constant speed. The label is drawn twice
///   (red on a light tint, white on solid red) and the white copy is masked to the fill,
///   so the text inverts exactly where the fill passes.
/// - Let go early: the fill springs back and nothing happens.
/// - Complete: success haptic, the label swaps to "Deleted", then everything resets after 2 seconds.
/// - VoiceOver: a single button whose default action confirms immediately, no hold required.
struct HoldToConfirm: View {
    private let holdDuration = 1.5

    @State private var progress: CGFloat = 0
    @State private var isPressing = false
    @State private var isConfirmed = false

    var body: some View {
        ZStack {
            label
                .foregroundStyle(.red)
                .background(Color.red.opacity(0.12))
            label
                .foregroundStyle(.white)
                .background(Color.red)
                .mask(alignment: .leading) {
                    GeometryReader { proxy in
                        Rectangle().frame(width: proxy.size.width * progress)
                    }
                }
        }
        .frame(width: 260, height: 60)
        .clipShape(.capsule)
        .onLongPressGesture(minimumDuration: holdDuration) {
            confirm()
        } onPressingChanged: { pressing in
            isPressing = pressing
            guard !isConfirmed else { return }
            withAnimation(pressing ? .linear(duration: holdDuration) : .spring(duration: 0.35)) {
                progress = pressing ? 1 : 0
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isPressing) { _, pressing in pressing }
        .sensoryFeedback(.success, trigger: isConfirmed) { _, confirmed in confirmed }
        .task(id: isConfirmed) {
            guard isConfirmed else { return }
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.spring(duration: 0.4)) {
                isConfirmed = false
                progress = 0
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isConfirmed ? "Deleted" : "Delete")
        .accessibilityHint("Hold to confirm")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { confirm() }
    }

    private var label: some View {
        Label(isConfirmed ? "Deleted" : "Hold to delete", systemImage: isConfirmed ? "checkmark" : "trash")
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func confirm() {
        isConfirmed = true
        withAnimation(.snappy(duration: 0.2)) { progress = 1 }
    }
}
