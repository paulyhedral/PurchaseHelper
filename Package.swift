// swift-tools-version:4.1
import PackageDescription

let package = Package(
    name: "PurchaseHelper",
    products: [
        .library(name: "PurchaseHelper", targets: ["PurchaseHelper"]),
        ],
    dependencies: [
        .package(url: "https://github.com/soffes/SAMKeychain.git", from: "1.5.3"),
        ],
    targets: [
        .target(
            name: "PurchaseHelper",
            dependencies: ["SAMKeychain"]),
        .testTarget(
            name: "PurchaseHelperTests",
            dependencies: ["PurchaseHelper"]),
        ]
)
