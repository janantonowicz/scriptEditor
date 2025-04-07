//
//  KeywordsManager.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 07/04/2025.
//


import SwiftUI

class KeywordsManager: ObservableObject {
    @Published var keywords: [String] {
        didSet {
            UserDefaults.standard.keywords = keywords
        }
    }
    
    init() {
        self.keywords = UserDefaults.standard.keywords
    }
    
    func add(keyword: String) {
        let normalized = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalized.isEmpty, !keywords.contains(normalized) else { return }
        keywords.append(normalized)
    }
    
    func remove(at offsets: IndexSet) {
        keywords.remove(atOffsets: offsets)
    }
}
