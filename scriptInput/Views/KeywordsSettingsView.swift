//
//  KeywordsSettingsView.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 07/04/2025.
//
import SwiftUI

struct KeywordsSettingsView: View {
    @StateObject private var manager = KeywordsManager()
    @State private var newKeyword: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Keywords that are highlighted")
                .font(.title)
                .padding(.bottom, 10)
            
            List {
                ForEach(Array(manager.keywords.enumerated()), id: \.offset) { index, keyword in
                    Text(keyword)
                        .contextMenu {
                            Button("Delete") {
                                manager.remove(at: IndexSet(integer: index))
                            }
                        }
                }
            }
            
            // New keyword bar
            HStack {
                TextField("Define new keyword", text: $newKeyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Add") {
                    manager.add(keyword: newKeyword)
                    newKeyword = ""
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct KeywordsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        KeywordsSettingsView()
    }
}
