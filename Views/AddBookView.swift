//
//  AddBookView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import SwiftData

struct AddBookView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let context: AddBookContext
    
    @State private var title = ""
    @State private var author = ""
    @State private var isOwned = true
    @State private var readingStatus: ReadingStatus = .toRead
    @State private var note = ""
    
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Kitap Bilgileri")) {
                    TextField("Kitap adi", text: $title)
                    TextField("Yazar", text: $author)
                }
                
                if context == .library {
                    Section("Okuma Durumu") {
                        Picker("Durum", selection: $readingStatus) {
                            ForEach(ReadingStatus.allCases) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                    }
                }
                
//                Section(header: Text("Durum")) {
//                    Toggle("Sahibim", isOn: $isOwned)
//                    
//                    Picker("Okuma Durumu", selection: $readingStatus) {
//                        ForEach(ReadingStatus.allCases) {status in Text(status.rawValue).tag(status)}
//                    }
//                }
                
                Section(header: Text("Not")) {
                    TextEditor(text: $note).frame(minHeight: 100)
                }
            }
            .navigationTitle(context == .library ? "Kitap Ekle" : "İstek Listesine Ekle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Iptal"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet"){
                        saveBook()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveBook() {
        let owned = (context == .library)

        let book = Book(
            title: title,
            author: author,
            isOwned: owned,
            readingStatus: owned ? readingStatus : .toRead,
            note: note.isEmpty ? nil : note
        )

        modelContext.insert(book)
        dismiss()
    }

    
    
//    private func saveBook() {
//        let book = Book(
//            title: title,
//            author: author,
//            isOwned: isOwned,
//            readingStatus: readingStatus,
//            note: note.isEmpty ? nil : note
//        )
//        modelContext.insert(book)
//        
//        dismiss()
//    }
}


