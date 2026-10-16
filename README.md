# MOMMI Collection

The exhibits of **MOMMI, the Museum of Modern Mobile Interfaces**: standalone UI/UX interactions built in SwiftUI.

Every exhibit in the MOMMI app has a **Copy this interaction** button. It copies a prompt for an AI coding agent that links back to the interaction's folder in this repo, so the agent can rebuild it in your project.

## Layout

```
Sources/MOMMICollection/
├── Catalog.swift                         # Interaction.all: every exhibit, in display order
├── Core/
│   ├── Interaction.swift                 # The exhibit model: metadata + live demo
│   └── Prompt.swift                      # Repo location and the copied agent prompt
└── <Name>/
    ├── <Name>.swift                      # The interaction itself. Imports only SwiftUI.
    └── <Name>+Catalog.swift              # Title, summary, tags, and details an agent must preserve
```

## Adding an interaction

1. Create `Sources/MOMMICollection/<Name>/`. The folder name is the interaction's `id` and part of its GitHub link, so don't rename it later.
2. Add `<Name>.swift`: the interaction as a self-contained SwiftUI view that imports only SwiftUI. Describe the behavior in a doc comment at the top. This is the file agents read.
3. Add `<Name>+Catalog.swift` with a `static let` `Interaction` entry. Use `keyDetails` for the specifics an agent must not lose: durations, springs, haptics, accessibility.
4. Append it to `Interaction.all` in `Catalog.swift`. Append rather than insert, so exhibit numbers stay stable.
