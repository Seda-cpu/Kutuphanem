//
//  BookPickerView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI
import SwiftData

struct BookPickerView: View {

    @Environment(\.dismiss) private var dismiss
    @Query private var books: [Book]

    @Binding var selectedBook: Book?

    @State private var searchText = ""

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return books
        }
        return books.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredBooks) { book in
                    Button {
                        selectedBook = book
                        dismiss()
                    } label: {
                        HStack {
                            Text(book.title)

                            Spacer()

                            if selectedBook?.id == book.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kitap Seç")
            .searchable(text: $searchText, prompt: "Kitap ara")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
        }
    }
}
