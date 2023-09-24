// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "openapi-example",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.5.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
        .package(url: "https://github.com/mattpolzin/VaporOpenAPI.git", .branch("openapikit-3"))
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name:"Vapor", package: "vapor"),
            "VaporOpenAPI",
            "Yams"
        ]),
        .executableTarget(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: [
            "App", 
            .product(name: "XCTVapor", package: "vapor")
        ])
    ]
)
