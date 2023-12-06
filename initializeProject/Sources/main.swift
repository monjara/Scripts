// The Swift Programming Language
// https://docs.swift.org/swift-book

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

private func main(args: [String]) {
    let args = args.dropFirst()
    guard let projectName = args.first else {
        print("error: requires arugument (github project name)")
        return
    }

    let fm = FileManager.default
    let currentDirectory = fm.currentDirectoryPath

    var isDir: ObjCBool = true
    let hasGitDir = fm.fileExists(atPath: "\(currentDirectory)/.git", isDirectory: &isDir)

    if !hasGitDir {
        shell("git init")
    }

    shell("git add .")
    shell("git commit -m 'first commit'")
    shell("git branch -M main")
    shell("git remote add origin git@github.com:monjara/\(projectName).git")
    shell("git push -u origin main")

    print("\n")
    print("successed!\n")
}

main(args: CommandLine.arguments)

