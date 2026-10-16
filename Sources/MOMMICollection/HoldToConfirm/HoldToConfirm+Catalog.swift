extension Interaction {
    static let holdToConfirm = Interaction(
        id: "HoldToConfirm",
        title: "Hold to Confirm",
        summary: "A destructive button that only fires after a deliberate hold. A fill sweeps across it and the label inverts color exactly where the fill passes.",
        symbol: "timer",
        tags: ["Buttons", "Gestures", "Haptics", "Destructive actions"],
        keyDetails: [
            "Hold for 1.5 s. The fill sweeps left to right with a linear animation, so progress maps 1:1 to time held.",
            "Letting go early springs the fill back with .spring(duration: 0.35) and does nothing.",
            "Draw the label twice (red on a 12% red tint, white on solid red) and mask the white copy to the fill width, so the text inverts where the fill passes.",
            "Light impact haptic on touch-down, success haptic on completion.",
            "After confirming, show \"Deleted\" with a checkmark, then reset after 2 s.",
            "VoiceOver: one button element whose default action confirms immediately, with no hold required.",
        ]
    ) {
        HoldToConfirm()
    }
}
