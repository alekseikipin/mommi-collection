/// A curated group of interactions. Each exhibition is one card in the app's feed: the card
/// loops its cover, and opening it lets you swipe through the rest.
public struct Exhibition: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    /// The interactions in viewing order. Never empty.
    public let exhibits: [Interaction]

    init(id: String, title: String, exhibits: [Interaction]) {
        precondition(!exhibits.isEmpty, "Exhibition \(id) has no exhibits")
        self.id = id
        self.title = title
        self.exhibits = exhibits
    }

    /// The interaction that loops on the feed card and opens first.
    public var cover: Interaction { exhibits[0] }

    /// The first exhibition that includes `interaction`, or a one-off exhibition of just that interaction.
    public static func containing(_ interaction: Interaction) -> Exhibition {
        all.first { $0.exhibits.contains(interaction) }
            ?? Exhibition(id: interaction.id, title: interaction.title, exhibits: [interaction])
    }
}
