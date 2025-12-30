//
//  WishlistView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import SwiftData

struct WishlistView: View {

    @Environment(\.modelContext) private var modelContext

    @Query(filter: #Predicate<Book> { $0.isOwned == false })
    private var wishlist: [Book]

    @State private var scannedISBN: String = ""

    enum ActiveSheet: Identifiable {
        case addBook
        case barcode
        var id: Int { hashValue }
    }

    @State private var activeSheet: ActiveSheet?

    var body: some View {
        NavigationStack {
            Group {
                if wishlist.isEmpty {
                    EmptyStateView(
                        icon: "star",
                        title: "İstek listen boş",
                        message: "Okumak istediğin kitapları buraya ekleyebilirsin.",
                        actionTitle: "Kitap Ekle"
                    ) {
                        scannedISBN = ""
                        activeSheet = .addBook
                    }
                } else {
                    List {
                        ForEach(wishlist) { book in
                            BookRowView(book: book)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                                    // 🟢 KÜTÜPHANEYE TAŞI
                                    Button {
                                        moveToLibrary(book)
                                    } label: {
                                        Label("Kütüphaneye Taşı", systemImage: "books.vertical")
                                    }
                                    .tint(.green)

                                    // 🔴 KALDIR
                                    Button(role: .destructive) {
                                        removeFromWishlist(book)
                                    } label: {
                                        Label("Kaldır", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("İstek Listem")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            scannedISBN = ""
                            activeSheet = .addBook
                        } label: {
                            Label("Manuel Ekle", systemImage: "square.and.pencil")
                        }

                        Button {
                            activeSheet = .barcode
                        } label: {
                            Label("Barkod ile Ekle", systemImage: "barcode.viewfinder")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {

                case .barcode:
                    BarcodeScannerView { isbn in
                        scannedISBN = isbn
                        activeSheet = .addBook
                    }

                case .addBook:
                    AddBookView(
                        context: .wishlist,
                        isbn: $scannedISBN
                    )
                }
            }
            
        }
       
        
        
    }

    // MARK: - Actionsq

    private func moveToLibrary(_ book: Book) {
        book.isOwned = true
        // SwiftData otomatik kaydeder
    }

    private func removeFromWishlist(_ book: Book) {
        modelContext.delete(book)
    }
}
