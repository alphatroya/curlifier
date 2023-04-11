// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "curlifier",
    products: [
        .library(
            name: "curlifier",
            targets: ["curlifier"]
        ),
    ],
    targets: [
        .target(
            name: "curlifier",
            dependencies: []
        ),
        .testTarget(
            name: "curlifierTests",
            dependencies: ["curlifier"]
        ),
    ]
)
