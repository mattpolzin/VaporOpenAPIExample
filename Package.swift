// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "openapi-example",
    platforms: [
       .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc.3"),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mattpolzin/VaporOpenAPI.git", .upToNextMinor(from: "0.0.1")),
        .package(url: "https://github.com/mattpolzin/OpenAPIReflection.git", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name:"Vapor", package: "vapor"),
            "VaporOpenAPI",
            "Yams"
        ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: [
            "App", 
            .product(name: "XCTVapor", package: "vapor")
        ])
    ]
)
