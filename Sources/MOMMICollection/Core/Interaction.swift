import SwiftUI

/// One exhibit in the MOMMI collection: a live demo plus everything an AI agent
/// needs to rebuild it in someone else's app.
public struct Interaction: Identifiable, Hashable, Sendable {
    /// Name of this interaction's folder under `Sources/MOMMICollection/`. Doubles as its stable ID.
    public let id: String
    public let title: String
    /// One or two sentences describing what the user sees and feels.
    public let summary: String
    /// SF Symbol shown on the home screen tile.
    public let symbol: String
    public let tags: [String]
    /// Specifics an agent must preserve when re-implementing it: timings, springs, haptics, accessibility.
    public let keyDetails: [String]
    private let makeDemo: @MainActor @Sendable () -> AnyView

    public init<Demo: View>(
        id: String,
        title: String,
        summary: String,
        symbol: String,
        tags: [String] = [],
        keyDetails: [String] = [],
        @ViewBuilder demo: @escaping @MainActor @Sendable () -> Demo
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.symbol = symbol
        self.tags = tags
        self.keyDetails = keyDetails
        self.makeDemo = { AnyView(demo()) }
    }

    /// The live, interactive demo.
    @MainActor public var demo: AnyView { makeDemo() }

    /// Exhibit number, from the interaction's position in ``Interaction/all``.
    public var number: Int { (Interaction.all.firstIndex(of: self) ?? 0) + 1 }

    public static func == (lhs: Interaction, rhs: Interaction) -> Bool { lhs.id == rhs.id }
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
