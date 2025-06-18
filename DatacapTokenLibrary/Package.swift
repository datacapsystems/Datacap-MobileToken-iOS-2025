// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DatacapTokenLibrary",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DatacapTokenLibrary",
            targets: ["DatacapTokenLibrary"]),
    ],
    targets: [
        .target(
            name: "DatacapTokenLibrary",
            path: "Sources"),
        .testTarget(
            name: "DatacapTokenLibraryTests",
            dependencies: ["DatacapTokenLibrary"]),
    ]
)