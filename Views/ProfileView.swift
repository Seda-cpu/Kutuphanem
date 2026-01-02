//
//  ProfileView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 1.01.2026.
//


import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ProfileView: View {
    
    
    @Query private var books: [Book]
    @Query(sort: \FeedItem.createdAt, order: .reverse) private var feedItems: [FeedItem]
    @State private var exportURL: URL?
    @State private var showExporter = false
    
    @AppStorage("profileDisplayName") private var displayName: String = "Okur"
    @AppStorage("defaultLibraryLayout") private var defaultLibraryLayout: String = "list" // "list" | "grid"
    @AppStorage("autoMarkFinished") private var autoMarkFinished: Bool = false
    
    @State private var isEditingName = false
    @State private var showBadgesSheet = false
    @State private var statsExpanded: Bool = true
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    headerCard

                    statsGrid

                    feedSection
                    // İleride buraya “Ayarlar” section’ları koyacağız.
                    // Örn: export, theme, backup, vs.
                }
                .padding()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {

                        Section("Görünüm") {
                            Button {
                                defaultLibraryLayout = "list"
                            } label: {
                                Label("Liste", systemImage: defaultLibraryLayout == "list" ? "checkmark" : "")
                            }

                            Button {
                                defaultLibraryLayout = "grid"
                            } label: {
                                Label("Grid", systemImage: defaultLibraryLayout == "grid" ? "checkmark" : "")
                            }
                        }

                        Toggle(isOn: $autoMarkFinished) {
                            Text("%100 olunca otomatik 'Okudum'")
                        }

                        Divider()

                        Button("Dışa Aktar (JSON)") {
                            exportBooks()
                        }

                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showBadgesSheet) {
                ReadingBadgesView(currentBadge: currentReadingBadge, totalPagesRead: pagesReadTotal)
            }
        }
        .fileExporter(
            isPresented: $showExporter,
            document: JSONDocument(fileURL: exportURL),
            contentType: .json,
            defaultFilename: "kutuphanem"
        ) { result in
            switch result {
            case .success:
                print("✅ Export başarılı")
            case .failure(let error):
                print("❌ Export başarısız:", error)
            }
        }
        
        
        
    }
    
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    if isEditingName {
                        TextField("Ad / Takma ad", text: $displayName)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        Text(displayName)
                            .font(.title2.weight(.semibold))
                    }

                    Button {
                        showBadgesSheet = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(currentReadingBadge.emoji) \(currentReadingBadge.title)")
                                .font(.subheadline)

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isEditingName.toggle()
                    }
                } label: {
                    Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }

            Text("Kütüphanenin özeti ve kişiselleştirme ayarları burada.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private var feedSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Akış")
                .font(.headline)

            if feedItems.isEmpty {
                Text("Henüz alıntı veya inceleme yok.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(feedItems) { item in
                        FeedItemCard(item: item)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    
    
    private var statsGrid: some View {
        DisclosureGroup(
            isExpanded: $statsExpanded
        ) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statTile(title: "Toplam", value: "\(totalCount)", systemImage: "books.vertical")
                statTile(title: "Okudum", value: "\(finishedCount)", systemImage: "checkmark.circle")
                statTile(title: "Okuyorum", value: "\(readingCount)", systemImage: "book")
                statTile(title: "İstek", value: "\(wishlistCount)", systemImage: "star")
                statTile(title: "Okunan Sayfa", value: "\(pagesReadTotal)", systemImage: "text.book.closed")
                statTile(title: "Yarım Bıraktım", value: "\(abandonedCount)", systemImage: "xmark.circle")
            }
            .padding(.top, 8)
        } label: {
            Text("İstatistikler")
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func statTile(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
            }

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
        )
    }
    
    
    
    private var libraryBooks: [Book] {
        books.filter { $0.isOwned == true }
    }

    private var wishlistBooks: [Book] {
        books.filter { $0.isOwned == false }
    }

    private var totalCount: Int { libraryBooks.count }
    private var wishlistCount: Int { wishlistBooks.count }

    private var readingCount: Int {
        libraryBooks.filter { $0.ReadingStatus == .reading }.count
    }
    
    private var finishedCount: Int {
        libraryBooks.filter { $0.ReadingStatus == .finished }.count
    }

    private var abandonedCount: Int {
        libraryBooks.filter { $0.ReadingStatus == .abandoned }.count
    }
    
    
    /// Okunan sayfa toplamı:
    /// - Okudum: pageCount varsa onu ekle
    /// - Okuyorum: currentPage varsa onu ekle
    private var pagesReadTotal: Int {
        var sum = 0
        for b in libraryBooks {
            switch b.ReadingStatus {
            case .finished:
                sum += (b.pageCount ?? 0)
            case .reading:
                sum += (b.currentPage ?? 0)
            default:
                break
            }
        }
        return sum
    }
    
    private var currentReadingBadge: ReadingBadge {
        ReadingBadge.badge(for: pagesReadTotal)
    }
    
    
    private func exportBooks() {
        let exportData = books.map { $0.toExportDTO() }
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let data = try encoder.encode(exportData)
            
            let fileName = "kutuphanem_\(Int(Date().timeIntervalSince1970)).json"
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            try data.write(to: url)
            
            exportURL = url
            showExporter = true
            
        } catch {
            print("❌ Export hatası:", error)
        }
    }
    
}
