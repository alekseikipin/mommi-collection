extension Interaction {
    /// Every exhibit in the museum. Its position here is its permanent exhibit number.
    ///
    /// Append new interactions to the end rather than inserting them, so exhibit numbers stay stable.
    public static let all: [Interaction] = [
        .pressableCard,
        .holdToConfirm,
        .likeBurst,
        .rubberBand,
    ]
}

extension Exhibition {
    /// The feed, in display order. The first exhibit of each exhibition is its cover.
    public static let all: [Exhibition] = [
        Exhibition(id: "tactile-buttons", title: "Tactile Buttons", exhibits: [.pressableCard, .holdToConfirm]),
        Exhibition(id: "playful-physics", title: "Playful Physics", exhibits: [.rubberBand, .likeBurst]),
    ]
}
