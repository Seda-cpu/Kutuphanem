//
//  AddQuoteView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI
import SwiftData

struct AddQuoteView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let book: Book

    @State private var quoteText: String = ""
    @State private var pageText: String = ""

    var body: some View {
        NavigationStack {
            Form {

                Section("Alıntı") {
                    TextEditor(text: $quoteText)
                        .frame(minHeight: 120)
                }

                Section("Sayfa (opsiyonel)") {
                    TextField("Örn: 42", text: $pageText)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Alıntı Ekle")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        saveQuote()
                    }
                    .disabled(quoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func saveQuote() {
        let pageNumber = Int(pageText)

        let newItem = FeedItem(
            kind: .quote,
            text: quoteText.trimmingCharacters(in: .whitespacesAndNewlines),
            page: pageNumber,
            book: book
        )

        modelContext.insert(newItem)
        dismiss()
    }
}
