//
//  CodeEditor.swift
//  scriptInput
//
//  Created by Jan Antonowicz on 07/04/2025.
//

import SwiftUI
import AppKit

struct CodeEditor: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// This function returns scrollView with textEditor
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.borderType = .noBorder
        scrollView.autohidesScrollers = true
        
        let textView = NSTextView()
        textView.isRichText = true
        textView.font = NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.delegate = context.coordinator
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        
        scrollView.documentView = textView
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            let selectedRange = textView.selectedRange()
            // change textView text if it is different from the user input
            if textView.string != text {
                textView.string = text
            }
            // syntax hilighting
            context.coordinator.applySyntaxHighlighting(in: textView)
            // retrieving cursor position
            textView.setSelectedRange(selectedRange)
        }
    }
}


extension CodeEditor {
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CodeEditor

        init(_ parent: CodeEditor) {
            self.parent = parent
        }
        
        // get text from textView and set it in CodeEditor (parent)
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
        
        func applySyntaxHighlighting(in textView: NSTextView) {
            let fullText = textView.string as NSString
            let attributedString = NSMutableAttributedString(string: fullText as String)
            
            // setting default font for text - monospaced and normal color
            let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont
                    .monospacedSystemFont(
                        ofSize: 14,
                        weight: .regular
                    ),
                .foregroundColor: NSColor.textColor
            ]
            attributedString.addAttributes(
                defaultAttributes,
                range: NSRange(
                    location: 0,
                    length: fullText.length
                )
            )
            
            
            //let keywords = ["if", "else", "for", "while", "func", "return", "print", "var", "let"]
            let keywords = UserDefaults.standard.keywords
            for keyword in keywords {
                let keywordPattern = "\\b\(keyword)\\b" // pattern for extracting whole words
                if let regex = try? NSRegularExpression(
                    pattern: keywordPattern,
                    options: []
                ) {
                    let matches = regex.matches(
                        in: attributedString.string,
                        options: [],
                        range: NSRange(
                            location: 0,
                            length: fullText.length
                        )
                    )
                    for match in matches {
                        let highlightAttributes: [NSAttributedString.Key: Any] = [
                            .foregroundColor: NSColor.red,
                            .font: NSFont.monospacedSystemFont(ofSize: 14, weight: .bold)
                        ]
                        attributedString.addAttributes(highlightAttributes, range: match.range)
                    }
                }
            }
    
            textView.textStorage?.setAttributedString(attributedString)
        }
        
        
        func textView(_ textView: NSTextView,
                      shouldChangeTextIn affectedCharRange: NSRange,
                      replacementString string: String?) -> Bool {

            guard let replacement = string else {
                return true
            }

            if replacement != "\n" {
                return true
            }

            let nsText = textView.string as NSString
            let loc = affectedCharRange.location

            if loc == 0 {
                return true
            }

            let previousChar = nsText.substring(with: NSRange(location: loc - 1, length: 1))

            if previousChar == "{" {

                let lineRange = nsText.lineRange(for: NSRange(location: loc - 1, length: 0))
                let currentLine = nsText.substring(with: lineRange)
                
                let whitespacePrefix = currentLine.prefix { $0 == " " || $0 == "\t" }
                
                let newIndent = String(whitespacePrefix) + "\t"
                let insertionText = "\n" + newIndent
                
                textView.insertText(insertionText, replacementRange: affectedCharRange)
                return false
            }
            
            return true
        }

    }
}


