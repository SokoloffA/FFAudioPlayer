// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FFAudioPlayer",
    products: [
        .library(
            name: "FFAudioPlayer",
            targets: ["FFAudioPlayer"]),
    ],
    targets: [
        .binaryTarget(name: "FFAudioPlayer", path: "./FFAudioPlayer.xcframework")
    ]
)
