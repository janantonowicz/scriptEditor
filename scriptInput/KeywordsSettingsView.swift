struct KeywordsSettingsView: View {
    @StateObject var manager = KeywordsManager()
    @State private var newKeyword: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Słowa kluczowe")
                .font(.title)
                .padding(.bottom, 10)
            
            List {
                ForEach(Array(manager.keywords.enumerated()), id: \.offset) { index, keyword in
                    TextField("Keyword", text: Binding(
                        get: { manager.keywords[index] },
                        set: { newValue in
                            manager.update(keyword: newValue, at: index)
                        }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .onDelete(perform: manager.remove)
            }
            
            HStack {
                TextField("Dodaj nowe słowo kluczowe", text: $newKeyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Dodaj") {
                    manager.add(keyword: newKeyword)
                    newKeyword = ""
                }
                .keyboardShortcut(.defaultAction)
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
