import CoreGraphics

/// Optional corner radius tokens for cards, buttons, and surfaces.
public struct ThemeCornerRadius: Equatable, Sendable {
    public let small: CGFloat
    public let medium: CGFloat
    public let large: CGFloat

    public init(
        small: CGFloat = 8,
        medium: CGFloat = 12,
        large: CGFloat = 20
    ) {
        self.small = small
        self.medium = medium
        self.large = large
    }

    public static let standard = ThemeCornerRadius()
}
