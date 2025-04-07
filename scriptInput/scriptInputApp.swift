//
//  scriptInputApp.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 06/04/2025.
//

import SwiftUI

@main
struct scriptInputApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            KeywordsSettingsView()
        }
    }
}
