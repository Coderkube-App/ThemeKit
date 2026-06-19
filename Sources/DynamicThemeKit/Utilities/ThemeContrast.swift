import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Accessibility utilities for ensuring readable color contrast.
public enum ThemeContrast {
    /// Minimum contrast ratio recommended by WCAG AA for normal text.
    public static let minimumAARatio: CGFloat = 4.5

    /// Returns a text color that meets contrast requirements against the background.
    public static func accessibleTextColor(
        for background: Color,
        preferred: Color,
        minimumRatio: CGFloat = minimumAARatio
    ) -> Color {
        let backgroundLuminance = relativeLuminance(of: background)
        let preferredLuminance = relativeLuminance(of: preferred)
        let ratio = contrastRatio(l1: backgroundLuminance, l2: preferredLuminance)

        if ratio >= minimumRatio {
            return preferred
        }

        let whiteLuminance = relativeLuminance(of: .white)
        let blackLuminance = relativeLuminance(of: .black)
        let whiteRatio = contrastRatio(l1: backgroundLuminance, l2: whiteLuminance)
        let blackRatio = contrastRatio(l1: backgroundLuminance, l2: blackLuminance)

        return whiteRatio >= blackRatio ? .white : .black
    }

    /// Adjusts a palette so text meets minimum contrast against the background.
    public static func adjustedPalette(
        _ palette: ThemeColorPalette,
        minimumRatio: CGFloat = minimumAARatio
    ) -> ThemeColorPalette {
        ThemeColorPalette(
            primary: palette.primary,
            secondary: palette.secondary,
            background: palette.background,
            text: accessibleTextColor(
                for: palette.background,
                preferred: palette.text,
                minimumRatio: minimumRatio
            ),
            accent: palette.accent
        )
    }

    private static func contrastRatio(l1: CGFloat, l2: CGFloat) -> CGFloat {
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    private static func relativeLuminance(of color: Color) -> CGFloat {
        #if canImport(UIKit)
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return weightedLuminance(red: red, green: green, blue: blue)
        #elseif canImport(AppKit)
        let nsColor = NSColor(color)
        guard let converted = nsColor.usingColorSpace(.sRGB) else { return 0 }
        return weightedLuminance(
            red: converted.redComponent,
            green: converted.greenComponent,
            blue: converted.blueComponent
        )
        #else
        return 0.5
        #endif
    }

    private static func weightedLuminance(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        func channel(_ value: CGFloat) -> CGFloat {
            value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * channel(red) + 0.7152 * channel(green) + 0.0722 * channel(blue)
    }
}
