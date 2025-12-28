//
//  BookDetailView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//
import SwiftUI

struct BookDetailView: View {
    
    @Bindable var book: Book
    
    var body: some View {
        Form {
            
            Section {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
            }
            
            Section("Kitap Bilgileri") {
                Text(book.title)
                Text(book.author).foregroundColor(.secondary)
            }
            
            Section("Okuma Durumu") {
                Picker("Durum", selection: $book.ReadingStatus) {
                    ForEach(ReadingStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
            }
            
            Section("Notlarım") {
                TextEditor(text: Binding(
                    get: { book.note ?? "" },
                    set: { book.note = $0.isEmpty ? nil : $0 }
                ))
                .frame(minHeight: 100)
            }
        }
        .navigationTitle("Kitap Detayı")
    }
}
