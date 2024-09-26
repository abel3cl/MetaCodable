#!/usr/bin/env bash
set -euo pipefail

# Build a fat binary
echo "👷🏻‍♂️ Building"
swift build -c release --arch arm64

# Copy the binary to artifactbundle bin directory
echo "📦 Copying binary"
cp .build/arm64-apple-macosx/release/ProtocolGen ProtocolGen.artifactbundle/bin

# Update info.json version
echo "🏷️ Updating version"
TAG=$(git describe HEAD --abbrev=0)
sed "s/{{VERSION}}/${TAG}/g" ProtocolGen.artifactbundle/info.json > tmpfile ; mv tmpfile ProtocolGen.artifactbundle/info.json

# Zip it
zip -r ProtocolGen.artifactbundle.zip ProtocolGen.artifactbundle/

# Update Package.swift - Replace executableTarget for binaryTarget
echo "🛠️ Updating Package.swift"
# TODO: Automate

#// MARK: ExecutableTarget
#.executableTarget(
#    name: "ProtocolGen",
#    dependencies: [
#        "PluginCore", "MetaCodable",
#        .product(name: "ArgumentParser", package: "swift-argument-parser"),
#        .product(name: "SwiftSyntax", package: "swift-syntax"),
#        .product(name: "SwiftParser", package: "swift-syntax"),
#        .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
#    ]
#),
#// MARK: Plugin

#.binaryTarget(
#    name: "ProtocolGen",
#    path: "./ProtocolGen.artifactbundle.zip"
#),
