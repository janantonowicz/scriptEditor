//
//  ContentView.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 06/04/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()

    @State var userCode: String = ""
    
    var body: some View {
        VStack {
            HStack {
                // Left side panel with run button and code editor
                editorPane
                
                // Right side panel with keywords editor, script output and errors if any exists
                outputPane
            }
        }
    }
}


extension ContentView {
    ///Code editing view:
    ///
    /// Contains:
    /// - navbar with run button and indicator showing whether the script is running
    /// - custom textEditor allowing user input with keywords hilighting function
    private var editorPane: some View {
        VStack {
            HStack {
                // run script button
                Button {
                    if !vm.isProcessRuning {
                        if let path = FileManager
                            .default
                            .urls(for: .cachesDirectory, in: .userDomainMask)
                            .first?
                            .appendingPathComponent("foo.swift")
                        {
                            vm.writeFile(path: path.path(), fileContent: userCode)
                            vm.runScript(path: path.path())
                        }
                    } else {
                        vm.terminateProcess()
                    }
                } label: {
                    Image(systemName: vm.isProcessRuning ? "stop.fill" : "play.fill")
                        .font(.title)
                        .foregroundStyle(Color.primary.opacity(0.6))
                }
                .buttonStyle(.plain)

                Text("Write your script below!")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                // Indicates if script is running (red color) or not (green color)
                Circle()
                    .fill(vm.isProcessRuning ? Color.red : Color.green)
                    .frame(width: 15, height: 15)
            }
            .padding(.top)
            .padding(.horizontal)
            CodeEditor(text: $userCode)
            //TextEditor(text: $userCode)
        }
        .frame(maxWidth: .infinity)
        .background(Color.primary.opacity(0.1))
    }
    
    /// Script output panel
    ///
    /// Displays results of the script after running
    /// If there are any errors, they are displayed bellow the script results
    /// On the bottom there is information whether the script returned with 0 or non-zero
    ///
    private var outputPane: some View {
        VStack {
            HStack {
                Text("Output")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // Opens settings view where user can edit keywords
                SettingsLink {
                    Text("Edit keywords")
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            ScrollView {
                Text(vm.solution)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if vm.messages != "" {
                VStack {
                    ScrollView {
                        Text(vm.messages)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.3))
                }
                .frame(maxHeight: 150)
            }
            if vm.exitCodeMessage != "" {
                Text(vm.exitCodeMessage)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.2))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

#Preview {
    ContentView()
}
