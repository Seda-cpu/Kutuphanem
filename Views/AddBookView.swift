//
//  AddBookView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddBookView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let context: AddBookContext
    
    @Binding var isbn: String
    
    @State private var title = ""
    @State private var author = ""
    @State private var isOwned = true
    @State private var readingStatus: ReadingStatus = .toRead
    @State private var note = ""
    
    
    
    @State private var pageCount = ""
    
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var selectedUIImage: UIImage?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Kitap Bilgileri")) {
                    TextField("Kitap adi", text: $title)
                    TextField("Yazar", text: $author)
                    TextField("ISBN (opsiyonel)", text: $isbn).keyboardType(.numberPad)
                    TextField("Sayfa sayısı (opsiyonel)", text: $pageCount)
                            .keyboardType(.numberPad)
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
                

                
                VStack(spacing: 12) {

                    // Kapak önizleme
                    if let image = selectedUIImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 220)
                            .cornerRadius(12)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 220)
                            .overlay(
                                Image(systemName: "book")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                            )
                    }

                    // Kapak seç
                    PhotosPicker(
                        selection: $selectedImageItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text(selectedUIImage == nil ? "Kapak Ekle" : "Kapağı Değiştir")
                            .foregroundColor(.blue)
                    }
                }
                
                
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
            
            .onChange(of: selectedImageItem){
                loadSelectedImage()
            }
            
        }
        
    }
    
    private func saveBook() {
        var coverFileName: String?
        
        if let image = selectedUIImage {
            coverFileName = ImageStorage.saveImage(image)
        }
        let owned = (context == .library)

        let book = Book(
            title: title,
            author: author,
            isOwned: owned,
            readingStatus: owned ? readingStatus : .toRead,
            isbn: isbn.isEmpty ? nil : isbn,
            pageCount: Int(pageCount),
            note: note.isEmpty ? nil : note,
            coverImageName: coverFileName
        )

        modelContext.insert(book)
        dismiss()
    }
    
    private func loadSelectedImage() {
        guard let selectedImageItem else { return }

        Task {
            if let data = try? await selectedImageItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedUIImage = image
            }
        }
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

