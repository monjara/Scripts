import Foundation
import ArgumentParser

@main
struct Tttt: ParsableCommand {
    @Option(name: .shortAndLong, help: "file extension (default: md)")
    var ext: String? = nil

    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date.now)
    }

    mutating func run() throws {
        let fileExtension = ext ?? "md"

        let fileName = "\(currentDate()).\(fileExtension)"

        let fm = FileManager()
        let tmpDir = NSTemporaryDirectory()
        let filePath = "\(tmpDir)\(fileName)"

        if !fm.fileExists(atPath: filePath) {
            fm.createFile(atPath: filePath, contents: nil)
        }
        print(filePath)
    }
}
