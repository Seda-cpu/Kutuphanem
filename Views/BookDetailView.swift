//
//  BookDetailView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI

struct BookDetailView: View {
    
    @Binding var book: Book
    
    var body: some View {
        Form {
            Section {
                RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.3)).frame(height: 200).overlay(Text("Kapak").foregroundColor(.secondary))
            }
            
            Section(header: Text("Kitap Bilgileri")) {
                Text(book.title).font(.headline)
                Text(book.author).foregroundStyle(.secondary)
            }
            
            Section(header: Text("Okuma Durumu")) {
                Picker("Durum", selection: $book.ReadingStatus) {
                    ForEach(ReadingStatus.allCases) { status in
                        Text(status.rawValue)
                            .tag(status)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text("Notlarım")) {
                TextEditor(text: Binding(
                    get: { book.note ?? "" },
                    set: { book.note = $0.isEmpty ? nil : $0 }
                ))
                .frame(minHeight: 100)
            }
        }
        .navigationTitle("Kitap Detayi")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    BookDetailView(
        book: .constant(
            Book(
                title: "Tutunamayanlar",
                author: "Oğuz Atay",
                isOwned: true,
                readingStatus: .finished
            )
        )
    )
}
