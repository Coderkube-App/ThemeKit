import Foundation

/// Controls how the app resolves light vs. dark appearance.
public enum ThemeAppearanceMode: String, Codable, CaseIterable, Sendable {
    /// Follow the system light/dark setting.
    case system
    /// Force light appearance regardless of system setting.
    case light
    /// Force dark appearance regardless of system setting.
    case dark

    /// Returns the opposite appearance mode for quick toggling.
    public var toggled: ThemeAppearanceMode {
        switch self {
        case .system: .dark
        case .light: .dark
        case .dark: .light
        }
    }

    /// Human-readable label for UI pickers.
    public var displayName: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }
}
