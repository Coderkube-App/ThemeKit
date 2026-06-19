import SwiftUI

/// A complete theme definition combining colors, typography, and optional layout tokens.
public struct AppTheme: Identifiable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let colors: ThemeColors
    public let typography: ThemeTypography
    public let spacing: ThemeSpacing
    public let cornerRadius: ThemeCornerRadius

    public init(
        id: String,
        name: String,
        colors: ThemeColors,
        typography: ThemeTypography = .standard,
        spacing: ThemeSpacing = .standard,
        cornerRadius: ThemeCornerRadius = .standard
    ) {
        self.id = id
        self.name = name
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.cornerRadius = cornerRadius
    }
}
