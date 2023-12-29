// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "applyXcode",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "applyXcode",
            dependencies: [
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
