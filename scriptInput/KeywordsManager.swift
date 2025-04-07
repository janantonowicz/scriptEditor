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
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !keywords.contains(trimmed) else { return }
        keywords.append(trimmed)
    }
    
    func update(keyword: String, at index: Int) {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        keywords[index] = trimmed
    }
    
    func remove(at offsets: IndexSet) {
        keywords.remove(atOffsets: offsets)
    }
}
