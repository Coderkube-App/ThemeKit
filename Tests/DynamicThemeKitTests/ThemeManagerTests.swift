import XCTest
@testable import DynamicThemeKit

@MainActor
final class ThemeManagerTests: XCTestCase {
    func testSetThemeUpdatesCurrentTheme() {
        let manager = ThemeManager(restorePersistedState: false)
        XCTAssertEqual(manager.currentTheme.id, ThemeCatalog.defaultTheme.id)

        manager.setTheme(ThemeCatalog.ocean)
        XCTAssertEqual(manager.currentTheme.id, "ocean")
        XCTAssertEqual(manager.currentTheme.name, "Ocean")
    }

    func testToggleDarkModeCyclesAppearance() {
        let manager = ThemeManager(
            appearanceMode: .light,
            restorePersistedState: false
        )

        manager.toggleDarkMode()
        XCTAssertEqual(manager.appearanceMode, .dark)

        manager.toggleDarkMode()
        XCTAssertEqual(manager.appearanceMode, .light)
    }

    func testEffectiveColorSchemeRespectsOverride() {
        let manager = ThemeManager(
            appearanceMode: .dark,
            restorePersistedState: false
        )

        XCTAssertEqual(manager.effectiveColorScheme(system: .light), .dark)
    }

    func testPersistenceRoundTrip() {
        let suiteName = "ThemeManagerTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let persistence = ThemePersistence(defaults: defaults)
        persistence.save(themeID: "sunset", appearanceMode: .dark)

        let manager = ThemeManager(
            persistence: persistence,
            restorePersistedState: true
        )

        XCTAssertEqual(manager.currentTheme.id, "sunset")
        XCTAssertEqual(manager.appearanceMode, .dark)
    }

    func testRegisterThemeAddsToAvailableThemes() {
        let manager = ThemeManager(restorePersistedState: false)
        let custom = DynamicPaletteGenerator.theme(
            id: "test-custom",
            name: "Test",
            seedColor: .green
        )

        manager.registerTheme(custom)
        XCTAssertTrue(manager.availableThemes.contains { $0.id == "test-custom" })
    }

    func testResolvedPaletteUsesDarkColorsInDarkMode() {
        let manager = ThemeManager(
            theme: ThemeCatalog.ocean,
            appearanceMode: .dark,
            restorePersistedState: false
        )

        let palette = manager.resolvedPalette(for: .dark)
        XCTAssertEqual(palette.accent, ThemeCatalog.ocean.colors.dark.accent)
        XCTAssertEqual(palette.background, ThemeCatalog.ocean.colors.dark.background)
    }
}
