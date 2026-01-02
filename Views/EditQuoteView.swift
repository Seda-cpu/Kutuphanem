//
//  EditQuoteView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI
import SwiftData

struct EditQuoteView: View {

    @Environment(\.dismiss) private var dismiss

    @Bindable var item: FeedItem

    @State private var text: String = ""
    @State private var pageText: String = ""

    var body: some View {
        NavigationStack {
            Form {

                Section("Alıntı") {
                    TextEditor(text: $text)
                        .frame(minHeight: 120)
                }

                Section("Sayfa") {
                    TextField("Örn: 42", text: $pageText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Alıntıyı Düzenle")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        save()
                    }
                }
            }
            .onAppear {
                text = item.text
                pageText = item.page.map(String.init) ?? ""
            }
        }
    }

    private func save() {
        item.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        item.page = Int(pageText)
        dismiss()
    }
}
