#!/usr/bin/env swift

import Foundation

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

private func main() {
    let fm = FileManager.default
    let currentDir = fm.currentDirectoryPath
    do {
        let dirs = try fm.contentsOfDirectory(atPath: currentDir)

        for d in dirs where fm.fileExists(atPath: "\(currentDir)/\(d)/Package.swift") {
            shell("""
                cd \(currentDir)/\(d) && \
                swift build -c release && \
                cp .build/release/\(d) ../bin/
            """)
        }
    } catch {

    }
}

main()
