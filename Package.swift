// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClipVault",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ClipVault", targets: ["ClipVault"])
    ],
    targets: [
        .executableTarget(
            name: "ClipVault",
            dependencies: [],
            path: "ClipVault"
        )
    ]
)
