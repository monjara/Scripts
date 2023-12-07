#!/usr/bin/env swift

import Foundation

struct ArgumentsParser {
    var clearOnly: Bool = false

    init(_ args: [String]) {
        for a in args {
            switch a {
            case "--clear", "-c":
                self.clearOnly = true
            default:
                break
            }
        }
    }
}

private func clear(fm: FileManager) throws {
    let binDir = "\(fm.currentDirectoryPath)/bin"
    do {
        let files = try fm.contentsOfDirectory(atPath: binDir)
        for f in files where f != ".keep" {
            try fm.removeItem(atPath: "\(binDir)/\(f)")
        }
    } catch {
        throw error
    }
}

private func shell(_ command: String) {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    print("\(output)\n")
}

private func main(_ args: ArgumentsParser) {
    let fm = FileManager.default

    do {
        try clear(fm: fm)
        if args.clearOnly {
            return
        }
    } catch {
        print(error)
        return
    }

    let currentDir = fm.currentDirectoryPath
    do {
        let dirs = try fm.contentsOfDirectory(atPath: currentDir)

        for d in dirs where fm.fileExists(atPath: "\(currentDir)/\(d)/Package.swift") {
            shell("""
                cd \(currentDir)/\(d) && \
                swift build -c release
            """)

            try fm.createSymbolicLink(
                at: URL(fileURLWithPath: "\(currentDir)/bin/\(d)"),
                withDestinationURL: URL(fileURLWithPath: "\(currentDir)/\(d)/.build/release/\(d)")
            )
        }
    } catch {
        print(error)
    }
}

main(ArgumentsParser(CommandLine.arguments))
