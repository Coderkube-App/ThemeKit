import SwiftUI

private struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue: ThemeManager? = nil
}

private struct ResolvedThemePaletteKey: EnvironmentKey {
    static let defaultValue: ThemeColorPalette? = nil
}

public extension EnvironmentValues {
    /// The shared theme manager injected into the view hierarchy.
    var themeManager: ThemeManager? {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }

    /// The resolved color palette for the current theme and appearance.
    var themePalette: ThemeColorPalette? {
        get { self[ResolvedThemePaletteKey.self] }
        set { self[ResolvedThemePaletteKey.self] = newValue }
    }
}

/// Injects `ThemeManager` and propagates resolved palette through the environment.
public struct ThemeEnvironmentModifier: ViewModifier {
    @ObservedObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    public init(themeManager: ThemeManager) {
        self.themeManager = themeManager
    }

    public func body(content: Content) -> some View {
        let effectiveScheme = themeManager.effectiveColorScheme(system: colorScheme)
        let palette = themeManager.resolvedPalette(for: effectiveScheme)

        content
            .environmentObject(themeManager)
            .environment(\.themeManager, themeManager)
            .environment(\.themePalette, palette)
            .preferredColorScheme(overrideColorScheme)
            .animation(
                themeManager.animationsEnabled ? .easeInOut(duration: 0.35) : nil,
                value: themeManager.currentTheme
            )
            .animation(
                themeManager.animationsEnabled ? .easeInOut(duration: 0.35) : nil,
                value: themeManager.appearanceMode
            )
    }

    private var overrideColorScheme: ColorScheme? {
        switch themeManager.appearanceMode {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

public extension View {
    /// Applies theme environment injection for the given manager.
    func themeEnvironment(_ themeManager: ThemeManager) -> some View {
        modifier(ThemeEnvironmentModifier(themeManager: themeManager))
    }
}
