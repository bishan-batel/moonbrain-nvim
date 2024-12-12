// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TreeSitterMoonbrain",
    products: [
        .library(name: "TreeSitterMoonbrain", targets: ["TreeSitterMoonbrain"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ChimeHQ/SwiftTreeSitter", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TreeSitterMoonbrain",
            dependencies: [],
            path: ".",
            sources: [
                "src/parser.c",
                // NOTE: if your language has an external scanner, add it here.
            ],
            resources: [
                .copy("queries")
            ],
            publicHeadersPath: "bindings/swift",
            cSettings: [.headerSearchPath("src")]
        ),
        .testTarget(
            name: "TreeSitterMoonbrainTests",
            dependencies: [
                "SwiftTreeSitter",
                "TreeSitterMoonbrain",
            ],
            path: "bindings/swift/TreeSitterMoonbrainTests"
        )
    ],
    cLanguageStandard: .c11
)
