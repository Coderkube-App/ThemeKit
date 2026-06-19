import Foundation

/// Persists theme selection and appearance mode using `UserDefaults`.
public struct ThemePersistence {
    public static let themeIDKey = "com.dynamicthemekit.selectedThemeID"
    public static let appearanceModeKey = "com.dynamicthemekit.appearanceMode"

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func save(themeID: String, appearanceMode: ThemeAppearanceMode) {
        defaults.set(themeID, forKey: Self.themeIDKey)
        defaults.set(appearanceMode.rawValue, forKey: Self.appearanceModeKey)
    }

    public func loadThemeID(default defaultID: String = ThemeCatalog.defaultTheme.id) -> String {
        defaults.string(forKey: Self.themeIDKey) ?? defaultID
    }

    public func loadAppearanceMode(default defaultMode: ThemeAppearanceMode = .system) -> ThemeAppearanceMode {
        guard
            let rawValue = defaults.string(forKey: Self.appearanceModeKey),
            let mode = ThemeAppearanceMode(rawValue: rawValue)
        else {
            return defaultMode
        }
        return mode
    }

    public func clear() {
        defaults.removeObject(forKey: Self.themeIDKey)
        defaults.removeObject(forKey: Self.appearanceModeKey)
    }
}
