// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DynamicThemeKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "DynamicThemeKit",
            targets: ["DynamicThemeKit"]
        )
    ],
    targets: [
        .target(
            name: "DynamicThemeKit",
            path: "Sources/DynamicThemeKit"
        ),
        .testTarget(
            name: "DynamicThemeKitTests",
            dependencies: ["DynamicThemeKit"],
            path: "Tests/DynamicThemeKitTests"
        )
    ]
)
