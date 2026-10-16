import Foundation

/// Where the collection's source lives publicly. Copied prompts link here.
public enum Repository {
    public static let url = URL(string: "https://github.com/alekseikipin/mommi-collection")!
    public static let branch = "main"
    /// Path from the repo root to the folder that holds each interaction.
    public static let sourceRoot = "Sources/MOMMICollection"
}

extension Interaction {
    /// GitHub folder that holds this interaction's source.
    public var sourceURL: URL {
        Repository.url.appending(path: "tree/\(Repository.branch)/\(Repository.sourceRoot)/\(id)")
    }

    /// What "Copy this interaction" puts on the clipboard: instructions for a coding agent
    /// working in the user's own project.
    public var prompt: String {
        let details = keyDetails.map { "- \($0)" }.joined(separator: "\n")
        return """
        Implement the "\(title)" interaction in my project.

        What it does:
        \(summary)

        Reference implementation (SwiftUI) from MOMMI, the Museum of Modern Mobile Interfaces. \
        Read every file in this folder before writing any code:
        \(sourceURL.absoluteString)

        Details to preserve exactly:
        \(details)

        How to adapt it:
        - Match my project's existing architecture, naming, and styling. Leave out the demo's sample content and colors unless I ask for them.
        - If my project doesn't use SwiftUI, port the behavior to the UI framework it does use, keeping the same timing, easing, and feedback.
        - Keep it accessible: VoiceOver labels and actions, Dynamic Type, and a Reduce Motion fallback.
        - When you're done, tell me where you added it and how to try it.
        """
    }
}
