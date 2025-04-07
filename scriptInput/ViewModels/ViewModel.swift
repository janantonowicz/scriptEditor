//
//  SwiftUIView.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 06/04/2025.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var solution: String = ""
    @Published var messages: String = ""
    
    @Published var exitCodeMessage: String = ""
    
    private var process: Process?
    private var output = Pipe()
    private var error = Pipe()
    
    
    public var isProcessRuning: Bool {
        return process != nil
    }
    
    /*
    func isProcessRunning() -> Bool {
        return process != nil
    }
     */
    
    /// This function runs swift script from the provided path
    func runScript(path: String) {
        solution = ""
        messages = ""
        process = Process()
        guard let process = process else { return }
        
        process.executableURL = URL(filePath: "/usr/bin/env")
        process.arguments = ["swift", path] // with arguments: /usr/bin/env swift foo.swift
        process.standardOutput = output
        process.standardError = error
        
        readFromPipe(output)
        readFromPipe(error, isError: true)
        
        do {
            try process.run()
        } catch let error {
            DispatchQueue.main.async {
                self.solution += "Error running process: \(error.localizedDescription)"
            }
        }
        
        process.terminationHandler = { process in
            let exitCode = process.terminationStatus
            DispatchQueue.main.async {
                if exitCode == 0 {
                    self.exitCodeMessage = "Script exited with 0"
                } else {
                    self.exitCodeMessage = "Script exited with non-zero code!"
                }
                self.solution += "Finished runnung script!\n"
                self.process = nil
                self.output = Pipe()
                self.error = Pipe()
            }
        }
    }
    
    
    private func readFromPipe(_ pipe: Pipe, isError: Bool = false) {
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if !data.isEmpty, let line = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if isError {
                        self.messages += line
                    } else {
                        self.solution += line
                    }
                }
            }
        }
    }
    
    
    func writeFile(path: String, fileContent: String) {
        let fileURL = URL(filePath: path)
        
        do {
            let cleanCode = fileContent
                //.replacingOccurrences(of: "“", with: "\"") // no longer required since i use custom textEditor
                //.replacingOccurrences(of: "”", with: "\"")
                //.replacingOccurrences(of: ":", with: ":")
            try cleanCode.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File written succesfully to \(path)")
        } catch let error {
            print("Error writing file: \(error)")
        }
    }
    
    func terminateProcess() {
        process?.terminate()
        process = nil
        output = Pipe()
        error = Pipe()
    }
}
