import SwiftUI

/// Built-in themes shipped with DynamicThemeKit.
public enum ThemeCatalog {
    public static let all: [AppTheme] = [defaultTheme, ocean, sunset]

    public static let defaultTheme = AppTheme(
        id: "default",
        name: "Default",
        colors: ThemeColors(
            light: ThemeColorPalette(
                primary: Color(red: 0.10, green: 0.10, blue: 0.12),
                secondary: Color(red: 0.45, green: 0.45, blue: 0.50),
                background: Color(red: 0.98, green: 0.98, blue: 0.99),
                text: Color(red: 0.10, green: 0.10, blue: 0.12),
                accent: Color(red: 0.00, green: 0.48, blue: 1.00)
            ),
            dark: ThemeColorPalette(
                primary: Color(red: 0.95, green: 0.95, blue: 0.97),
                secondary: Color(red: 0.65, green: 0.65, blue: 0.70),
                background: Color(red: 0.08, green: 0.08, blue: 0.10),
                text: Color(red: 0.95, green: 0.95, blue: 0.97),
                accent: Color(red: 0.40, green: 0.70, blue: 1.00)
            )
        )
    )

    public static let ocean = AppTheme(
        id: "ocean",
        name: "Ocean",
        colors: ThemeColors(
            light: ThemeColorPalette(
                primary: Color(red: 0.05, green: 0.25, blue: 0.45),
                secondary: Color(red: 0.30, green: 0.55, blue: 0.70),
                background: Color(red: 0.93, green: 0.97, blue: 0.99),
                text: Color(red: 0.05, green: 0.20, blue: 0.35),
                accent: Color(red: 0.00, green: 0.65, blue: 0.85)
            ),
            dark: ThemeColorPalette(
                primary: Color(red: 0.75, green: 0.90, blue: 0.98),
                secondary: Color(red: 0.45, green: 0.70, blue: 0.85),
                background: Color(red: 0.04, green: 0.12, blue: 0.20),
                text: Color(red: 0.85, green: 0.95, blue: 1.00),
                accent: Color(red: 0.20, green: 0.80, blue: 0.95)
            )
        ),
        typography: ThemeTypography(
            largeTitle: .system(size: 34, weight: .bold, design: .serif),
            title: .system(size: 28, weight: .semibold, design: .serif),
            headline: .system(size: 17, weight: .semibold, design: .default),
            body: .system(size: 17, weight: .regular, design: .default),
            caption: .system(size: 12, weight: .regular, design: .default)
        )
    )

    public static let sunset = AppTheme(
        id: "sunset",
        name: "Sunset",
        colors: ThemeColors(
            light: ThemeColorPalette(
                primary: Color(red: 0.45, green: 0.15, blue: 0.10),
                secondary: Color(red: 0.70, green: 0.40, blue: 0.30),
                background: Color(red: 1.00, green: 0.97, blue: 0.94),
                text: Color(red: 0.35, green: 0.12, blue: 0.08),
                accent: Color(red: 0.95, green: 0.45, blue: 0.20)
            ),
            dark: ThemeColorPalette(
                primary: Color(red: 1.00, green: 0.90, blue: 0.85),
                secondary: Color(red: 0.85, green: 0.60, blue: 0.50),
                background: Color(red: 0.15, green: 0.08, blue: 0.10),
                text: Color(red: 1.00, green: 0.92, blue: 0.88),
                accent: Color(red: 1.00, green: 0.55, blue: 0.30)
            )
        ),
        typography: ThemeTypography(
            largeTitle: .system(size: 34, weight: .heavy, design: .rounded),
            title: .system(size: 28, weight: .bold, design: .rounded),
            headline: .system(size: 17, weight: .bold, design: .rounded),
            body: .system(size: 17, weight: .medium, design: .rounded),
            caption: .system(size: 12, weight: .medium, design: .rounded)
        ),
        spacing: ThemeSpacing(xs: 6, sm: 10, md: 18, lg: 28, xl: 36),
        cornerRadius: ThemeCornerRadius(small: 10, medium: 16, large: 24)
    )

    /// Looks up a theme by its stable identifier.
    public static func theme(withID id: String) -> AppTheme? {
        all.first { $0.id == id }
    }
}
