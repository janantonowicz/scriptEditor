//
//  SwiftUIView.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 06/04/2025.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var solution: String = ""
    
    private var process: Process?
    private var output = Pipe()
    private var error = Pipe()
    
    func runScript(path: String) {
        process = Process()
        guard let process = process else { return }
        
        process.executableURL = URL(filePath: "/usr/bin/env")
        process.arguments = ["swift", path] // with arguments: /usr/bin/env swift foo.swift
        process.standardOutput = output
        process.standardError = error
        
        do {
            try process.run()
        } catch let error {
            DispatchQueue.main.async {
                self.solution += "Error: \(error.localizedDescription)"
            }
        }
        
        process.terminationHandler = { _ in
            DispatchQueue.main.async {
                self.solution += "Code run succesfully!"
            }
        }
        
    }
}
