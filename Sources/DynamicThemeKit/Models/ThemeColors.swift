import SwiftUI

/// A resolved set of semantic colors for the active appearance.
public struct ThemeColorPalette: Equatable, Sendable {
    public let primary: Color
    public let secondary: Color
    public let background: Color
    public let text: Color
    public let accent: Color

    public init(
        primary: Color,
        secondary: Color,
        background: Color,
        text: Color,
        accent: Color
    ) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.text = text
        self.accent = accent
    }
}

/// Light and dark color palettes bundled together for a single theme.
public struct ThemeColors: Equatable, Sendable {
    public let light: ThemeColorPalette
    public let dark: ThemeColorPalette

    public init(light: ThemeColorPalette, dark: ThemeColorPalette) {
        self.light = light
        self.dark = dark
    }

    /// Resolves the palette for the given color scheme.
    public func palette(for colorScheme: ColorScheme) -> ThemeColorPalette {
        colorScheme == .dark ? dark : light
    }
}
