//
//  LibraryView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI

struct LibraryView: View {
    
    
    @State private var books: [Book] = [
        Book(id: UUID(), title: "Hekaton'la Son Tango", author: "Mustafa Merter", isOwned: true, readingStatus: .finished, note: "Bazı bölümleri tekrar okumak istiyorum.", coverImageName: nil),
        Book(id: UUID(), title: "Puslu Kıtalar Atlası", author: "İhsan Oktay Anar", isOwned: true, readingStatus: .reading, note: "nil", coverImageName: nil),
        
    ]
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($books.filter { $0.wrappedValue.isOwned}) { $book in NavigationLink {
                    BookDetailView(book: $book)
                } label: {
                    BookRowView(book: book)
                }}
            }.navigationTitle(Text("Kütüphanem"))
        }
    }
}

#Preview {
    LibraryView()
}
