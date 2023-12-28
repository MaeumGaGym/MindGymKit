// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MindGymKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MindGymKit", targets: ["MindGymKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.5.0"),
    ],
    targets: [
        .target(
            name: "MindGymKit",
            dependencies: [
                "RxSwift"
            ],
            path: "MindGymKit"
        ),
        .testTarget(
            name: "MindGymKitTests",
            dependencies: ["MindGymKit"]),
    ]
)
