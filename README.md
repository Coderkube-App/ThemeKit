# DynamicThemeKit

A reusable SwiftUI package that provides a complete **dynamic theming engine** for iOS and macOS applications. Switch themes at runtime, override system appearance, persist user preferences, and style views with a small set of ergonomic modifiers.

## Features

- **Light & Dark Mode** — Adapts to system appearance or manual light/dark override
- **Custom Themes** — Define multiple themes with colors, typography, spacing, and corner radius tokens
- **Runtime Switching** — UI updates instantly without app restart
- **Central ThemeManager** — `ObservableObject` with `@Published` state and `setTheme(_:)` / `toggleDarkMode()`
- **Environment Integration** — Inject via `@EnvironmentObject` and custom `EnvironmentKey`s
- **View Extensions** — `.themedBackground()`, `.themedTextColor()`, `.themedAccent()`, and more
- **Persistence** — Saves selected theme and appearance mode to `UserDefaults`
- **Preview Helpers** — Test all themes in SwiftUI previews
- **Bonus** — Animated transitions, dynamic palette generation, WCAG-aware contrast handling

## Requirements

- iOS 17+ / macOS 14+
- Swift 5.9+
- Xcode 15+

## Installation

### Swift Package Manager

Add DynamicThemeKit to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../ThemeKit") // or your remote URL
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["DynamicThemeKit"]
    )
]
```

Or in Xcode: **File → Add Package Dependencies** and point to this repository.

## Quick Start

### 1. Create and inject the theme manager

```swift
import SwiftUI
import DynamicThemeKit

@main
struct MyApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .themeEnvironment(themeManager)
        }
    }
}
```

`ThemeManager` automatically restores the last selected theme and appearance mode from `UserDefaults` on launch.

### 2. Style views with extensions

```swift
struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Hello, World!")
                .themedFont(.largeTitle)
                .themedTextColor()

            Text("Accent label")
                .themedAccent()

            Button("Get Started") { }
                .buttonStyle(ThemedButtonStyle(variant: .primary))
        }
        .themedPadding(.all, .lg)
        .themedBackground()
    }
}
```

### 3. Switch themes at runtime

```swift
struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Picker("Theme", selection: themeSelection) {
            ForEach(themeManager.availableThemes) { theme in
                Text(theme.name).tag(theme.id)
            }
        }

        Button("Toggle Dark Mode") {
            themeManager.toggleDarkMode()
        }
    }

    private var themeSelection: Binding<String> {
        Binding(
            get: { themeManager.currentTheme.id },
            set: { themeManager.setTheme(id: $0) }
        )
    }
}
```

## Package Structure

```
Sources/DynamicThemeKit/
├── DynamicThemeKit.swift          # Module entry point
├── Models/
│   ├── AppTheme.swift             # Complete theme definition
│   ├── ThemeAppearanceMode.swift  # system / light / dark
│   ├── ThemeCatalog.swift         # Built-in themes (Default, Ocean, Sunset)
│   ├── ThemeColors.swift          # Light & dark color palettes
│   ├── ThemeCornerRadius.swift    # Corner radius tokens
│   ├── ThemeSpacing.swift         # Spacing scale
│   └── ThemeTypography.swift      # Font tokens
├── Manager/
│   └── ThemeManager.swift         # Central ObservableObject
├── Environment/
│   └── ThemeEnvironment.swift     # Environment injection
├── Extensions/
│   └── View+Theming.swift         # View modifiers
├── Utilities/
│   ├── DynamicPaletteGenerator.swift  # Generate themes from a seed color
│   ├── ThemeContrast.swift            # WCAG contrast handling
│   └── ThemePersistence.swift         # UserDefaults storage
├── Previews/
│   └── ThemePreviewHelpers.swift    # Preview utilities
└── Demo/
    └── ThemeDemoView.swift          # Interactive demo
```

## Core API

### ThemeManager

| Method / Property | Description |
|---|---|
| `currentTheme` | Currently active `AppTheme` (`@Published`) |
| `appearanceMode` | `.system`, `.light`, or `.dark` (`@Published`) |
| `availableThemes` | All selectable themes |
| `setTheme(_:)` | Switch to a theme at runtime |
| `setTheme(id:)` | Switch by theme identifier |
| `toggleDarkMode()` | Toggle between light and dark |
| `setAppearanceMode(_:)` | Set appearance explicitly |
| `registerTheme(_:)` | Add a custom theme at runtime |
| `resolvedPalette(for:)` | Get colors for a color scheme |
| `animationsEnabled` | Enable/disable transition animations |

### View Extensions

| Modifier | Description |
|---|---|
| `.themedBackground()` | Apply themed background color |
| `.themedTextColor()` | Apply themed text color |
| `.themedAccent()` | Apply themed accent color |
| `.themedFont(_:)` | Apply themed typography |
| `.themedCornerRadius(_:)` | Apply themed corner radius |
| `.themedPadding(_:_:)` | Apply themed spacing |
| `.themeEnvironment(_:)` | Inject `ThemeManager` into the hierarchy |

### Built-in Themes

- **Default** — Clean neutral palette with system rounded typography
- **Ocean** — Cool blues with serif headings
- **Sunset** — Warm oranges with bold rounded typography

## Defining Custom Themes

```swift
let myTheme = AppTheme(
    id: "brand",
    name: "Brand",
    colors: ThemeColors(
        light: ThemeColorPalette(
            primary: .black,
            secondary: .gray,
            background: .white,
            text: .black,
            accent: .blue
        ),
        dark: ThemeColorPalette(
            primary: .white,
            secondary: .gray,
            background: .black,
            text: .white,
            accent: .cyan
        )
    ),
    typography: .standard,
    spacing: ThemeSpacing(md: 20),
    cornerRadius: ThemeCornerRadius(medium: 14)
)

themeManager.registerTheme(myTheme)
themeManager.setTheme(myTheme)
```

## Dynamic Palette Generation

Generate a full theme from a single seed color:

```swift
let generated = DynamicPaletteGenerator.theme(
    id: "user-pick",
    name: "My Color",
    seedColor: .purple
)
themeManager.registerTheme(generated)
themeManager.setTheme(generated)
```

## Accessibility

`ThemeContrast` automatically adjusts text colors to meet WCAG AA contrast ratios (4.5:1) when palettes are resolved. You can also use it directly:

```swift
let safeText = ThemeContrast.accessibleTextColor(
    for: backgroundColor,
    preferred: textColor
)
```

## SwiftUI Previews

```swift
#Preview("Ocean Theme") {
    ThemePreview.container(theme: ThemeCatalog.ocean) {
        ThemeSampleCard()
    }
}

#Preview("All Themes") {
    ThemePreview.AllThemesGallery()
}

#Preview("Light vs Dark") {
    ThemePreview.LightDarkComparison(theme: ThemeCatalog.sunset)
}
```

## Interactive Demo

Use the built-in demo view to explore all features:

```swift
import SwiftUI
import DynamicThemeKit

struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ThemeDemoView()
        }
    }
}
```

The demo includes theme pickers, appearance toggles, dynamic palette generation, and live component previews.

## Persistence

Theme selection is stored in `UserDefaults` under:

- `com.dynamicthemekit.selectedThemeID`
- `com.dynamicthemekit.appearanceMode`

Disable restoration for tests or previews:

```swift
ThemeManager(restorePersistedState: false)
```

Clear saved preferences:

```swift
ThemePersistence().clear()
```

## Architecture Overview

```mermaid
flowchart TD
    App[App / Root View] --> TE[themeEnvironment]
    TE --> TM[ThemeManager]
    TM --> Models[AppTheme + Tokens]
    TM --> Persist[ThemePersistence]
    TE --> Env[@EnvironmentObject]
    Env --> Views[SwiftUI Views]
    Views --> Ext[View+Theming Modifiers]
    Ext --> TM
```

## Testing

```bash
swift test
```

Tests cover theme switching, appearance toggling, persistence round-trips, and palette resolution.

## License

This package is provided under the license in [LICENSE](LICENSE).
