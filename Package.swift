// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Halftop",
    defaultLocalization: "en",
    platforms: [.macOS(.v14)],
    products: [.executable(name: "Halftop", targets: ["Halftop"])],
    targets: [
        .executableTarget(
            name: "Halftop",
            resources: [.process("Resources")]
        ),
        .executableTarget(
            name: "HalftopLidDaemon",
            path: "Sources/HalftopLidDaemon"
        )
    ]
)
