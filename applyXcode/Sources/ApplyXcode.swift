// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ShellOut
import ArgumentParser

let XCODE_BUILD_SERVER = "xcode-build-server"
let XCODE_BUILD_SERVER_REPOSITORY_URL = "https://github.com/SolaWing/xcode-build-server"

@main
struct ApplyXcode: ParsableCommand {
    @Argument(help: "project name")
    var projectName: String
    @Flag
    var isWorkSpace: Bool = false

    mutating func run() throws {
        let typeArgs = isWorkSpace ? "-workspace" : "-project"
        let ext = isWorkSpace ? "xcworkspace" : "xcodeproj"

        do {
            let output = try shellOut(
                to: XCODE_BUILD_SERVER,
                arguments: [
                    "config",
                    "-scheme",
                    projectName,
                    typeArgs,
                    "*.\(ext)"
                ]
            )
            print(output)
        } catch {
            print("failed to execute xcode-build-server command")
        }
    }
}
