import SwiftUI

/// Typography tokens used across themed views.
public struct ThemeTypography: Equatable, Sendable {
    public let largeTitle: Font
    public let title: Font
    public let headline: Font
    public let body: Font
    public let caption: Font

    public init(
        largeTitle: Font,
        title: Font,
        headline: Font,
        body: Font,
        caption: Font
    ) {
        self.largeTitle = largeTitle
        self.title = title
        self.headline = headline
        self.body = body
        self.caption = caption
    }

    /// Default typography using the system rounded design.
    public static let standard = ThemeTypography(
        largeTitle: .system(size: 34, weight: .bold, design: .rounded),
        title: .system(size: 28, weight: .semibold, design: .rounded),
        headline: .system(size: 17, weight: .semibold, design: .rounded),
        body: .system(size: 17, weight: .regular, design: .rounded),
        caption: .system(size: 12, weight: .regular, design: .rounded)
    )
}
