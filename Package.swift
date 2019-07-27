// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPCommonLibrary",
    platforms: [
        .iOS(.v10),
//        .macOS(.v10_12),
//        .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SPCommonLibrary",
            targets: ["SPCommonLibrary"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-beta.6"),
         .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0")
//          .package(url: "https://github.com/realm/realm-cocoa.git", from: "3.17.1"),
//           .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SPCommonLibrary",
            dependencies: ["Alamofire","SnapKit"],path :"Sources"),
        .testTarget(
            name: "SPCommonLibraryTests",
            dependencies: ["SPCommonLibrary"]),
    ],
     swiftLanguageVersions: [.v5]
)
