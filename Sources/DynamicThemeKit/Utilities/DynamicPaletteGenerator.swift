import SwiftUI

/// Generates dynamic color palettes from a user-provided seed color.
public enum DynamicPaletteGenerator {
    /// Creates a full theme from a single accent/seed color.
    public static func theme(
        id: String,
        name: String,
        seedColor: Color,
        isDarkBase: Bool = false
    ) -> AppTheme {
        let lightPalette = palette(from: seedColor, isDark: false)
        let darkPalette = palette(from: seedColor, isDark: true)

        return AppTheme(
            id: id,
            name: name,
            colors: ThemeColors(
                light: isDarkBase ? darkPalette : lightPalette,
                dark: isDarkBase ? darkPalette : darkPalette
            )
        )
    }

    /// Builds a semantic palette by deriving shades from a seed color.
    public static func palette(from seed: Color, isDark: Bool) -> ThemeColorPalette {
        let components = rgbaComponents(of: seed)

        let background = Color(
            red: isDark ? components.red * 0.15 : 0.97,
            green: isDark ? components.green * 0.15 : 0.97,
            blue: isDark ? components.blue * 0.15 : 0.98
        )

        let primary = Color(
            red: isDark ? min(components.red + 0.6, 1.0) : components.red * 0.4,
            green: isDark ? min(components.green + 0.6, 1.0) : components.green * 0.4,
            blue: isDark ? min(components.blue + 0.6, 1.0) : components.blue * 0.4
        )

        let secondary = Color(
            red: isDark ? components.red * 0.8 + 0.2 : components.red * 0.6 + 0.3,
            green: isDark ? components.green * 0.8 + 0.2 : components.green * 0.6 + 0.3,
            blue: isDark ? components.blue * 0.8 + 0.2 : components.blue * 0.6 + 0.3
        )

        let text = Color(
            red: isDark ? 0.95 : 0.10,
            green: isDark ? 0.95 : 0.10,
            blue: isDark ? 0.97 : 0.12
        )

        let accent = seed

        return ThemeContrast.adjustedPalette(
            ThemeColorPalette(
                primary: primary,
                secondary: secondary,
                background: background,
                text: text,
                accent: accent
            )
        )
    }

    private static func rgbaComponents(of color: Color) -> (red: Double, green: Double, blue: Double, alpha: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
        #elseif canImport(AppKit)
        let nsColor = NSColor(color)
        guard let converted = nsColor.usingColorSpace(.sRGB) else {
            return (0.5, 0.5, 0.5, 1.0)
        }
        return (
            Double(converted.redComponent),
            Double(converted.greenComponent),
            Double(converted.blueComponent),
            Double(converted.alphaComponent)
        )
        #else
        return (0.5, 0.5, 0.5, 1.0)
        #endif
    }
}
