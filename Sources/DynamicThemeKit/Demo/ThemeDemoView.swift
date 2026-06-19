import SwiftUI

/// Interactive demo showcasing runtime theme switching and live UI updates.
public struct ThemeDemoView: View {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) private var colorScheme
    @State private var seedColor: Color = .purple
    @State private var customThemeEnabled = false

    private var palette: ThemeColorPalette {
        themeManager.resolvedPalette(
            for: themeManager.effectiveColorScheme(system: colorScheme)
        )
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: themeManager.currentTheme.spacing.lg) {
                    ThemeSampleCard()

                    themePickerSection
                    appearanceSection
                    dynamicPaletteSection
                    livePreviewSection
                }
                .padding(themeManager.currentTheme.spacing.md)
            }
            .themedBackground()
            .navigationTitle("DynamicThemeKit")
            .themedFont(.headline)
            .themedTextColor()
        }
        .themeEnvironment(themeManager)
    }

    // MARK: - Sections

    private var themePickerSection: some View {
        themedSection(title: "Theme") {
            Picker("Theme", selection: themeSelection) {
                ForEach(themeManager.availableThemes) { theme in
                    Text(theme.name).tag(theme.id)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var appearanceSection: some View {
        themedSection(title: "Appearance") {
            Picker("Mode", selection: $themeManager.appearanceMode) {
                ForEach(ThemeAppearanceMode.allCases, id: \.self) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Button("Toggle Dark Mode") {
                themeManager.toggleDarkMode()
            }
            .buttonStyle(ThemedButtonStyle(variant: .secondary))
        }
    }

    private var dynamicPaletteSection: some View {
        themedSection(title: "Dynamic Palette") {
            ColorPicker("Seed Color", selection: $seedColor, supportsOpacity: false)

            Toggle("Use Custom Generated Theme", isOn: $customThemeEnabled)
                .onChange(of: customThemeEnabled) { _, enabled in
                    if enabled {
                        applyGeneratedTheme()
                    } else {
                        themeManager.setTheme(ThemeCatalog.defaultTheme)
                    }
                }
                .onChange(of: seedColor) { _, _ in
                    if customThemeEnabled {
                        applyGeneratedTheme()
                    }
                }

            if customThemeEnabled {
                Text("Palette generated from your selected color.")
                    .themedFont(.caption)
                    .foregroundStyle(palette.secondary)
            }
        }
    }

    private var livePreviewSection: some View {
        themedSection(title: "Live Components") {
            HStack(spacing: themeManager.currentTheme.spacing.sm) {
                Button("Primary") {}
                    .buttonStyle(ThemedButtonStyle(variant: .primary))

                Button("Accent") {}
                    .buttonStyle(ThemedButtonStyle(variant: .accent))
            }

            VStack(alignment: .leading, spacing: themeManager.currentTheme.spacing.xs) {
                Text("Large Title").themedFont(.largeTitle).themedTextColor()
                Text("Headline").themedFont(.headline).themedTextColor()
                Text("Body text with secondary styling")
                    .themedFont(.body)
                    .foregroundStyle(palette.secondary)
                Text("Caption").themedFont(.caption).themedAccent()
            }
        }
    }

    // MARK: - Helpers

    private var themeSelection: Binding<String> {
        Binding(
            get: { themeManager.currentTheme.id },
            set: { themeManager.setTheme(id: $0) }
        )
    }

    private func applyGeneratedTheme() {
        let generated = DynamicPaletteGenerator.theme(
            id: "custom-generated",
            name: "Custom",
            seedColor: seedColor
        )
        themeManager.registerTheme(generated)
        themeManager.setTheme(generated)
    }

    @ViewBuilder
    private func themedSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: themeManager.currentTheme.spacing.sm) {
            Text(title)
                .themedFont(.headline)
                .themedTextColor()

            VStack(alignment: .leading, spacing: themeManager.currentTheme.spacing.md) {
                content()
            }
            .padding(themeManager.currentTheme.spacing.md)
            .themedBackground()
            .themedCornerRadius(.medium)
            .overlay(
                RoundedRectangle(cornerRadius: themeManager.currentTheme.cornerRadius.medium)
                    .stroke(palette.secondary.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

/// Button style that reads colors from the active theme.
public struct ThemedButtonStyle: ButtonStyle {
    public enum Variant {
        case primary
        case secondary
        case accent
    }

    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    private let variant: Variant

    public init(variant: Variant) {
        self.variant = variant
    }

    public func makeBody(configuration: Configuration) -> some View {
        let palette = themeManager.resolvedPalette(for: colorScheme)

        configuration.label
            .themedFont(.headline)
            .padding(.horizontal, themeManager.currentTheme.spacing.md)
            .padding(.vertical, themeManager.currentTheme.spacing.sm)
            .background(backgroundColor(palette: palette))
            .foregroundStyle(foregroundColor(palette: palette))
            .themedCornerRadius(.medium)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }

    private func backgroundColor(palette: ThemeColorPalette) -> Color {
        switch variant {
        case .primary: palette.primary
        case .secondary: palette.secondary.opacity(0.2)
        case .accent: palette.accent
        }
    }

    private func foregroundColor(palette: ThemeColorPalette) -> Color {
        switch variant {
        case .primary: palette.background
        case .secondary: palette.text
        case .accent: palette.background
        }
    }
}

#Preview {
    ThemeDemoView()
}
