/// DynamicThemeKit
///
/// A reusable SwiftUI theming engine with runtime theme switching,
/// light/dark mode support, persistence, and accessibility-aware colors.
///
/// ## Quick Start
///
/// ```swift
/// import DynamicThemeKit
/// import SwiftUI
///
/// @main
/// struct MyApp: App {
///     @StateObject private var themeManager = ThemeManager()
///
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///                 .themeEnvironment(themeManager)
///         }
///     }
/// }
/// ```
public enum DynamicThemeKit {
    public static let version = "1.0.0"
}
