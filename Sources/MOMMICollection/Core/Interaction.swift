import SwiftUI

/// One exhibit in the MOMMI collection: a live demo plus everything an AI agent
/// needs to rebuild it in someone else's app.
public struct Interaction: Identifiable, Hashable, Sendable {
    /// Name of this interaction's folder under `Sources/MOMMICollection/`. Doubles as its stable ID.
    public let id: String
    public let title: String
    /// One or two sentences describing what the user sees and feels.
    public let summary: String
    /// SF Symbol used wherever the interaction is listed.
    public let symbol: String
    public let tags: [String]
    /// Specifics an agent must preserve when re-implementing it: timings, springs, haptics, accessibility.
    public let keyDetails: [String]
    private let makeDemo: @MainActor @Sendable () -> AnyView
    private let makePreview: (@MainActor @Sendable () -> AnyView)?

    /// - Parameters:
    ///   - demo: The live interaction, shown full screen.
    ///   - preview: A version that plays itself on a loop with no touch input, shown on feed cards.
    ///     It must not trigger haptics.
    public init<Demo: View, Preview: View>(
        id: String,
        title: String,
        summary: String,
        symbol: String,
        tags: [String] = [],
        keyDetails: [String] = [],
        @ViewBuilder demo: @escaping @MainActor @Sendable () -> Demo,
        @ViewBuilder preview: @escaping @MainActor @Sendable () -> Preview
    ) {
        self.init(
            id: id, title: title, summary: summary, symbol: symbol, tags: tags, keyDetails: keyDetails,
            makeDemo: { AnyView(demo()) },
            makePreview: { AnyView(preview()) }
        )
    }

    /// An interaction without a looping preview. Feed cards show its demo at rest instead.
    public init<Demo: View>(
        id: String,
        title: String,
        summary: String,
        symbol: String,
        tags: [String] = [],
        keyDetails: [String] = [],
        @ViewBuilder demo: @escaping @MainActor @Sendable () -> Demo
    ) {
        self.init(
            id: id, title: title, summary: summary, symbol: symbol, tags: tags, keyDetails: keyDetails,
            makeDemo: { AnyView(demo()) },
            makePreview: nil
        )
    }

    private init(
        id: String,
        title: String,
        summary: String,
        symbol: String,
        tags: [String],
        keyDetails: [String],
        makeDemo: @escaping @MainActor @Sendable () -> AnyView,
        makePreview: (@MainActor @Sendable () -> AnyView)?
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.symbol = symbol
        self.tags = tags
        self.keyDetails = keyDetails
        self.makeDemo = makeDemo
        self.makePreview = makePreview
    }

    /// The live, interactive demo.
    @MainActor public var demo: AnyView { makeDemo() }

    /// The self-playing loop for feed cards, or the demo at rest if there isn't one.
    @MainActor public var preview: AnyView { makePreview?() ?? makeDemo() }

    /// Exhibit number, from the interaction's position in ``Interaction/all``.
    public var number: Int { (Interaction.all.firstIndex(of: self) ?? 0) + 1 }

    public static func == (lhs: Interaction, rhs: Interaction) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
