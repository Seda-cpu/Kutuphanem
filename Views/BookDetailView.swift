//
//  BookDetailView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//
import SwiftUI
import SwiftData
import PhotosUI

struct BookDetailView: View {
    
    @Bindable var book: Book
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        Form {
            
            Section {
                VStack {
                    coverView
                        .frame(height: 220)
                        .cornerRadius(12)
                    
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text(book.coverImageName == nil ? "Kapak Ekle" : "Kapağı Değiştir")
                            .foregroundColor(.blue)
                    }
                }
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
        .navigationTitle("Kitap Detayı").onChange(of: selectedItem){
            loadSelectedImage()
        }
    }
    
    @ViewBuilder
    private var coverView: some View {
        if let name = book.coverImageName,
           let image = ImageStorage.loadImage(named: name) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "book")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )
        }
    }

    // MARK: - Load Image
    private func loadSelectedImage() {
        guard let selectedItem else { return }

        Task {
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data),
               let fileName = ImageStorage.saveImage(image) {

                book.coverImageName = fileName
                // SwiftData otomatik kaydeder
            }
        }
    }
    
}
