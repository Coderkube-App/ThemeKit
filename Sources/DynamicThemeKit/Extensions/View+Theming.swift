import SwiftUI

public extension View {
    /// Applies the themed background color from the current palette.
    func themedBackground() -> some View {
        modifier(ThemedBackgroundModifier())
    }

    /// Applies the themed primary text color from the current palette.
    func themedTextColor() -> some View {
        modifier(ThemedTextColorModifier())
    }

    /// Applies the themed accent color from the current palette.
    func themedAccent() -> some View {
        modifier(ThemedAccentModifier())
    }

    /// Applies themed typography for a semantic text style.
    func themedFont(_ style: ThemedFontStyle) -> some View {
        modifier(ThemedFontModifier(style: style))
    }

    /// Applies themed corner radius from the current theme.
    func themedCornerRadius(_ size: ThemedCornerRadiusSize) -> some View {
        modifier(ThemedCornerRadiusModifier(size: size))
    }

    /// Applies themed padding from the current theme spacing scale.
    func themedPadding(_ edges: Edge.Set = .all, _ size: ThemedSpacingSize) -> some View {
        modifier(ThemedPaddingModifier(edges: edges, size: size))
    }
}

public enum ThemedFontStyle {
    case largeTitle
    case title
    case headline
    case body
    case caption
}

public enum ThemedCornerRadiusSize {
    case small
    case medium
    case large
}

public enum ThemedSpacingSize {
    case xs
    case sm
    case md
    case lg
    case xl
}

// MARK: - Modifiers

private struct ThemedBackgroundModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.background(themeManager.resolvedPalette(for: colorScheme).background)
    }
}

private struct ThemedTextColorModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.foregroundStyle(themeManager.resolvedPalette(for: colorScheme).text)
    }
}

private struct ThemedAccentModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.foregroundStyle(themeManager.resolvedPalette(for: colorScheme).accent)
    }
}

private struct ThemedFontModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    let style: ThemedFontStyle

    func body(content: Content) -> some View {
        content.font(font(for: style, typography: themeManager.currentTheme.typography))
    }

    private func font(for style: ThemedFontStyle, typography: ThemeTypography) -> Font {
        switch style {
        case .largeTitle: typography.largeTitle
        case .title: typography.title
        case .headline: typography.headline
        case .body: typography.body
        case .caption: typography.caption
        }
    }
}

private struct ThemedCornerRadiusModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    let size: ThemedCornerRadiusSize

    func body(content: Content) -> some View {
        content.clipShape(RoundedRectangle(cornerRadius: radius))
    }

    private var radius: CGFloat {
        let tokens = themeManager.currentTheme.cornerRadius
        switch size {
        case .small: return tokens.small
        case .medium: return tokens.medium
        case .large: return tokens.large
        }
    }
}

private struct ThemedPaddingModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    let edges: Edge.Set
    let size: ThemedSpacingSize

    func body(content: Content) -> some View {
        content.padding(edges, spacing)
    }

    private var spacing: CGFloat {
        let tokens = themeManager.currentTheme.spacing
        switch size {
        case .xs: return tokens.xs
        case .sm: return tokens.sm
        case .md: return tokens.md
        case .lg: return tokens.lg
        case .xl: return tokens.xl
        }
    }
}
