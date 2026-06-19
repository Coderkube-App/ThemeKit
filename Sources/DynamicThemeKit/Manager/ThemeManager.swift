import SwiftUI

/// Central coordinator for runtime theme and appearance management.
@MainActor
public final class ThemeManager: ObservableObject {
    /// The currently active theme. Updates propagate instantly to subscribed views.
    @Published public private(set) var currentTheme: AppTheme

    /// How light/dark appearance is resolved (system override or forced mode).
    @Published public var appearanceMode: ThemeAppearanceMode {
        didSet { persistIfNeeded() }
    }

    /// All themes available for selection.
    @Published public var availableThemes: [AppTheme]

    /// When `true`, theme transitions are animated.
    @Published public var animationsEnabled: Bool

    private let persistence: ThemePersistence
    private let persistSelection: Bool

    public init(
        theme: AppTheme = ThemeCatalog.defaultTheme,
        appearanceMode: ThemeAppearanceMode = .system,
        availableThemes: [AppTheme] = ThemeCatalog.all,
        animationsEnabled: Bool = true,
        persistence: ThemePersistence = ThemePersistence(),
        restorePersistedState: Bool = true
    ) {
        self.persistence = persistence
        self.persistSelection = restorePersistedState
        self.animationsEnabled = animationsEnabled
        self.availableThemes = availableThemes

        if restorePersistedState {
            let savedThemeID = persistence.loadThemeID()
            let savedMode = persistence.loadAppearanceMode()
            self.currentTheme = availableThemes.first { $0.id == savedThemeID } ?? theme
            self.appearanceMode = savedMode
        } else {
            self.currentTheme = theme
            self.appearanceMode = appearanceMode
        }
    }

    /// Switches to the given theme at runtime.
    public func setTheme(_ theme: AppTheme) {
        guard currentTheme != theme else { return }
        currentTheme = theme
        persistIfNeeded()
    }

    /// Switches to a theme by its identifier.
    public func setTheme(id: String) {
        guard let theme = availableThemes.first(where: { $0.id == id }) else { return }
        setTheme(theme)
    }

    /// Toggles between light and dark appearance modes.
    public func toggleDarkMode() {
        switch appearanceMode {
        case .system:
            appearanceMode = .dark
        case .light:
            appearanceMode = .dark
        case .dark:
            appearanceMode = .light
        }
    }

    /// Sets the appearance mode explicitly.
    public func setAppearanceMode(_ mode: ThemeAppearanceMode) {
        appearanceMode = mode
    }

    /// Registers an additional theme at runtime (e.g., user-generated palettes).
    public func registerTheme(_ theme: AppTheme) {
        guard !availableThemes.contains(where: { $0.id == theme.id }) else { return }
        availableThemes.append(theme)
    }

    /// Resolves the active color palette for the given color scheme.
    public func resolvedPalette(for colorScheme: ColorScheme) -> ThemeColorPalette {
        let effectiveScheme = effectiveColorScheme(system: colorScheme)
        let palette = currentTheme.colors.palette(for: effectiveScheme)
        return ThemeContrast.adjustedPalette(palette)
    }

    /// Resolves which `ColorScheme` should be used given system settings and overrides.
    public func effectiveColorScheme(system: ColorScheme) -> ColorScheme {
        switch appearanceMode {
        case .system: system
        case .light: .light
        case .dark: .dark
        }
    }

    private func persistIfNeeded() {
        guard persistSelection else { return }
        persistence.save(themeID: currentTheme.id, appearanceMode: appearanceMode)
    }
}
