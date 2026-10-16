extension Interaction {
    /// Every exhibit in the museum, in display order.
    ///
    /// Append new interactions to the end rather than inserting them, so exhibit numbers stay stable.
    public static let all: [Interaction] = [
        .pressableCard,
        .holdToConfirm,
    ]
}
