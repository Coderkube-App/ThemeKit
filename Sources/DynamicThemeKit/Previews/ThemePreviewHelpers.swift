import SwiftUI

/// Preview helpers for testing themes without boilerplate setup.
public enum ThemePreview {
    /// Wraps content with a `ThemeManager` configured for previews.
    @MainActor
    public static func container(
        theme: AppTheme = ThemeCatalog.defaultTheme,
        appearanceMode: ThemeAppearanceMode = .system,
        animationsEnabled: Bool = false,
        @ViewBuilder content: () -> some View
    ) -> some View {
        let manager = ThemeManager(
            theme: theme,
            appearanceMode: appearanceMode,
            animationsEnabled: animationsEnabled,
            restorePersistedState: false
        )
        return content()
            .themeEnvironment(manager)
    }

    /// A grid preview showing all built-in themes side by side.
    public struct AllThemesGallery: View {
        public init() {}

        public var body: some View {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(ThemeCatalog.all) { theme in
                        ThemePreview.container(theme: theme) {
                            ThemeSampleCard()
                        }
                    }
                }
                .padding()
            }
        }
    }

    /// A preview that cycles through light and dark modes.
    public struct LightDarkComparison: View {
        let theme: AppTheme

        public init(theme: AppTheme = ThemeCatalog.defaultTheme) {
            self.theme = theme
        }

        public var body: some View {
            HStack(spacing: 0) {
                ThemePreview.container(theme: theme, appearanceMode: .light) {
                    ThemeSampleCard()
                }
                ThemePreview.container(theme: theme, appearanceMode: .dark) {
                    ThemeSampleCard()
                }
            }
        }
    }
}

/// Reusable sample card for previews and documentation.
public struct ThemeSampleCard: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    public init() {}

    public var body: some View {
        let palette = themeManager.resolvedPalette(for: colorScheme)

        VStack(alignment: .leading, spacing: themeManager.currentTheme.spacing.md) {
            Text(themeManager.currentTheme.name)
                .themedFont(.title)
                .themedTextColor()

            Text("Primary & accent colors update instantly when the theme changes.")
                .themedFont(.body)
                .foregroundStyle(palette.secondary)

            HStack(spacing: themeManager.currentTheme.spacing.sm) {
                colorSwatch(palette.primary, label: "Primary")
                colorSwatch(palette.accent, label: "Accent")
                colorSwatch(palette.secondary, label: "Secondary")
            }

            Text("Accent Action")
                .themedFont(.headline)
                .themedAccent()
                .padding(.horizontal, themeManager.currentTheme.spacing.md)
                .padding(.vertical, themeManager.currentTheme.spacing.sm)
                .background(palette.accent.opacity(0.15))
                .themedCornerRadius(.medium)
        }
        .padding(themeManager.currentTheme.spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .themedBackground()
        .themedCornerRadius(.large)
        .overlay(
            RoundedRectangle(cornerRadius: themeManager.currentTheme.cornerRadius.large)
                .stroke(palette.secondary.opacity(0.3), lineWidth: 1)
        )
    }

    private func colorSwatch(_ color: Color, label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: themeManager.currentTheme.cornerRadius.small)
                .fill(color)
                .frame(width: 44, height: 44)
            Text(label)
                .themedFont(.caption)
                .foregroundStyle(color)
        }
    }
}

#Preview("All Themes") {
    ThemePreview.AllThemesGallery()
}

#Preview("Light vs Dark") {
    ThemePreview.LightDarkComparison(theme: ThemeCatalog.ocean)
}
