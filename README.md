# MOMMI Collection

The exhibits of **MOMMI, the Museum of Modern Mobile Interfaces**: standalone UI/UX interactions built in SwiftUI.

Every exhibit in the MOMMI app has a **Copy this interaction** button. It copies a prompt for an AI coding agent that links back to the interaction's folder in this repo, so the agent can rebuild it in your project.

## Layout

```
Sources/MOMMICollection/
├── Catalog.swift                 # Interaction.all (every exhibit) and Exhibition.all (the feed)
├── Core/
│   ├── Interaction.swift         # One exhibit: metadata, live demo, looping preview
│   ├── Exhibition.swift          # A curated group of exhibits; one card in the app's feed
│   └── Prompt.swift              # Repo location and the copied agent prompt
└── <Name>/
    ├── <Name>.swift              # The interaction itself. Imports only SwiftUI.
    └── <Name>+Catalog.swift      # Title, summary, tags, agent details, and the feed preview
```

In the app, the feed shows one large card per exhibition, looping its first exhibit. Opening a card shows that exhibit full screen; swiping up moves through the rest of the exhibition.

## Adding an interaction

1. Create `Sources/MOMMICollection/<Name>/`. The folder name is the interaction's `id` and part of its GitHub link, so don't rename it later.
2. Add `<Name>.swift`: the interaction as a self-contained SwiftUI view that imports only SwiftUI. Describe the behavior in a doc comment at the top. This is the file agents read.
   Split it in two: a *face* view that only draws a given state (pressed, progress, offset…) and the interactive view that turns touches into that state. The feed preview drives the same face, so it always matches the real thing.
3. Add `<Name>+Catalog.swift` with a `static let` `Interaction` entry. Use `keyDetails` for the specifics an agent must not lose: durations, springs, haptics, accessibility. Pass a `preview` that loops the face through the interaction on a timer, with no touch input and no haptics.
4. Append it to `Interaction.all` in `Catalog.swift`. Append rather than insert, so exhibit numbers stay stable.
5. Add it to an exhibition in `Exhibition.all`, or start a new one. The first exhibit is the one that loops on the feed card.
