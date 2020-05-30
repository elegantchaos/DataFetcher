// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "DataFetcher",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "DataFetcher",
            targets: ["DataFetcher"]),
    ],
    dependencies: [
         .package(url: "https://github.com/elegantchaos/Coercion.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "DataFetcher",
            dependencies: ["Coercion"]),
        .testTarget(
            name: "DataFetcherTests",
            dependencies: ["DataFetcher"]),
    ]
)
