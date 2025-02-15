//
//  QuickOpenPreviewView.swift
//  CodeEdit
//
//  Created by Pavel Kasila on 20.03.22.
//

import SwiftUI
import WorkspaceClient
import CodeFile
import CodeEditor

struct QuickOpenPreviewView: View {
    var item: WorkspaceClient.FileItem
    @State var content: String = ""
    @State var loaded = false
    @State var error: String?

    var body: some View {
        VStack {
            if loaded {
                ThemedCodeView($content, language: .init(url: item.url), editable: false)
            } else if let error = error {
                Text(error)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loaded = false
            error = nil
            DispatchQueue(label: "austincondiff.CodeEdit.quickOpen.preview").async {
                do {
                    let data = try String(contentsOf: item.url)
                    DispatchQueue.main.async {
                        self.content = data
                        self.loaded = true
                    }
                } catch let error {
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
