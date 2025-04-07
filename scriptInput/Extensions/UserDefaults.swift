//
//  UserDefaults.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 07/04/2025.
//

import SwiftUI

extension UserDefaults {
    private enum Keys {
        static let keywords = "keywords"
    }
    
    var keywords: [String] {
        get {
            return (array(forKey: Keys.keywords) as? [String])
                ?? ["if", "else", "for", "while", "func", "return", "print", "var", "let", "sleep", "import", "match", "case", "do", "try", "catch"]
        }
        set {
            set(newValue, forKey: Keys.keywords)
        }
    }
}

