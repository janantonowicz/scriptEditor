//
//  scriptInputTests.swift
//  scriptInputTests
//
//  Created by Jan Antonowicz on 06/04/2025.
//

import XCTest
import Combine
@testable import scriptInput

final class ViewModelTests: XCTestCase {
    
    var vm: ViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        vm = ViewModel()
    }

    override func tearDown() {
        vm = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Initial Test
    
    func testInitialProcessStatus() {
        XCTAssertFalse(vm.isProcessRuning, "There should be no process running just after init.")
    }
    
    // MARK: - Writing file test

    func testWriteFile() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("foo.swift")
        let expected = "print(\"Hello, World!\")"
        
        vm.writeFile(path: tempURL.path, fileContent: expected)
        
        do {
            let content = try String(contentsOf: tempURL, encoding: .utf8)
            XCTAssertEqual(content, expected, "Content in saved file must be the same as expected.")
        } catch {
            XCTFail("Could not read file: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Runnung script tests
    func testRunScriptSuccess() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("foo.swift")
        let filePath = tempURL.path
        let scriptContent = "print(\"Test\")"
        vm.writeFile(path: filePath, fileContent: scriptContent)
        
        let exitCodeExpectation = expectation(description: "ExitCodeExpectation")
        
        vm.$exitCodeMessage
            .sink { message in
                if !message.isEmpty {
                    exitCodeExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        vm.runScript(path: filePath)
        
        wait(for: [exitCodeExpectation], timeout: 5.0)
        XCTAssertTrue(self.vm.exitCodeMessage.contains("0"), "Code run succesfully if message contains 0.")
    }
    
    // MARK: - Terminating process using terminateProcess function
    func testTerminateProcess() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("foo.swift")
        let filePath = tempURL.path
        
        // function will sleep to take longer time
        let scriptContent = """
        import Foundation
        sleep(3)
        print("Waited for 3 seconds!")
        """
        vm.writeFile(path: filePath, fileContent: scriptContent)
        
        vm.runScript(path: filePath)
        
        // Check if process is running after one second.
        let processStartedExpectation = expectation(description: "ProcessStarted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.vm.isProcessRuning, "Process is running")
            processStartedExpectation.fulfill()
        }
        wait(for: [processStartedExpectation], timeout: 2.0)
        
        // Stop process
        vm.terminateProcess()
        XCTAssertFalse(vm.isProcessRuning, "Process should be terminated.")
    }
}

