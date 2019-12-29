// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "openapi-example",
    platforms: [
       .macOS(.v10_14)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta"),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mattpolzin/VaporOpenAPI.git", .branch("master"))
    ],
    targets: [
        .target(name: "App", dependencies: [
            "Vapor",
            "VaporOpenAPI",
            "Yams"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "XCTVapor"])
    ]
)
