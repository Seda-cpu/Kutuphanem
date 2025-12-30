//
//  LibraryView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<Book> { $0.isOwned == true })
    private var books: [Book]
    
    @State private var layout: LibraryLayout = .list
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
                
                
                if books.isEmpty {
                    EmptyStateView(icon: "books.vertical", title: "Kütüphanen boş", message: "Henüz kütüphanene kitap eklemedin.", actionTitle: "Kitap Ekle") {
                        scannedISBN = ""
                        activeSheet = .addBook
                    }
                } else {
                    if layout == .list {
                        listView.transition(.libraryLayout)
                    }else {
                        gridView
                            .transition(.libraryLayout)
                    }
                }

            }
            .navigationTitle("Kütüphanem")
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

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        toggleLayout()
                    } label: {
                        Image(systemName: layout == .list ? "square.grid.2x2" : "list.bullet")
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
                        context: .library,
                        isbn: $scannedISBN    // ⭐ binding
                    )
                }
            }
            .animation(.easeInOut(duration: 0.22), value: layout)
            
        }
        
        
        
    }
    
    private func deleteBook(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(books[index])
        }
    }
    
    private func toggleLayout() {
        withAnimation(.easeInOut(duration: 0.22)) {
            layout = (layout == .list) ? .grid : .list
        }
    }
    
    private var listView: some View {
        List {
            ForEach(books) { book in
                NavigationLink {
                    BookDetailView(book: book)
                } label: {
                    BookRowView(book: book)
                }
            }
            .onDelete(perform: deleteBook)
        }
    }
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 16) {
                ForEach(books) { book in
                    NavigationLink {
                        BookDetailView(book: book)
                    } label: {
                        BookGridItemView(book: book)
                    }
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.25), value: books)
        }
    }
    
    
}
extension AnyTransition {
    static var libraryLayout: AnyTransition {
        .asymmetric(
            insertion: .opacity
                .combined(with: .scale(scale: 0.98)),
            removal: .opacity
                .combined(with: .scale(scale: 1.02))
        )
    }
}
