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

    @State private var showAddBook = false

    var body: some View {
        NavigationStack {
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

                        // 🔴 KALDIR (tamamen sil)
                        Button(role: .destructive) {
                            removeFromWishlist(book)
                        } label: {
                            Label("Kaldır", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("İstek Listem")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView(context: .wishlist)
            }
        }
    }

    // MARK: - Actions

    private func moveToLibrary(_ book: Book) {
        book.isOwned = true
        // SwiftData otomatik kaydeder
    }

    private func removeFromWishlist(_ book: Book) {
        modelContext.delete(book)
    }
}

//import SwiftUI
//import SwiftData
//
//struct WishlistView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    
//    @Query(filter: #Predicate<Book> { $0.isOwned == false })
//    private var wishlist: [Book]
//    
//    @State private var showAddBook = false
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(wishlist) { book in
//                    VStack(alignment: .leading) {
//                        Text(book.title).font(.headline)
//                        Text(book.author).foregroundColor(.secondary)
//                    }
//                    .swipeActions {
//                        Button("Kütüphaneye Taşı") {
//                            book.isOwned = true
//                        }
//                        .tint(.green)
//                    }
//                }
//                .onDelete { indexSet in
//                    indexSet.forEach {
//                        modelContext.delete(wishlist[$0])
//                    }
//                }
//            }
//            .navigationTitle("İstek Listesi")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        showAddBook = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            .sheet(isPresented: $showAddBook) {
//                AddBookView(context: .wishlist)
//            }
//        }
//    }
//}
