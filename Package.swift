// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTAK",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftTAK",
            targets: ["SwiftTAK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftTAK",
            dependencies: ["ZIPFoundation"]),
        .testTarget(
            name: "SwiftTAKTests",
            dependencies: ["SwiftTAK", "ZIPFoundation"]),
    ]
)
