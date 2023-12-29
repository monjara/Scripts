// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import ShellOut
import ArgumentParser

let XCODE_BUILD_SERVER = "xcode-build-server"
let XCODE_BUILD_SERVER_REPOSITORY_URL = "https://github.com/SolaWing/xcode-build-server"

private func hasDir(dir: String) -> Bool {
    var isDir: ObjCBool = true
    return FileManager.default.fileExists(atPath: "/tmp/\(dir)", isDirectory: &isDir)
}

private func retrieveXcodebuildServer() {
    guard let repositoryUrl = URL(string: XCODE_BUILD_SERVER_REPOSITORY_URL) else {
        print("failed to create url")
        return
    }

    do {
        try shellOut(to: .gitClone(url: repositoryUrl, to: "/tmp/xcode-build-server"))
    } catch {
        print("failed to retrieve xcode-build-server")
        return
    }
}

@main
struct ApplyXcode: ParsableCommand {
    @Argument(help: "project name")
    var projectName: String
    @Flag
    var isWorkSpace: Bool = false

    mutating func run() throws {

        let hasXcodeBuildServer = hasDir(dir: XCODE_BUILD_SERVER)
        if !hasXcodeBuildServer {
            retrieveXcodebuildServer()
        }

        let typeArgs = isWorkSpace ? "-workspace" : "-project"
        let ext = isWorkSpace ? "xcworkspace" : "xcodeproj"

        do {
            let output = try shellOut(
                to: "/tmp/xcode-build-server/xcode-build-server",
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
