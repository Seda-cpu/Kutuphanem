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
    @State private var exportURL: URL?
    @State private var showExporter = false
    
    @AppStorage("profileDisplayName") private var displayName: String = "Okur"
    @AppStorage("defaultLibraryLayout") private var defaultLibraryLayout: String = "list" // "list" | "grid"
    @AppStorage("autoMarkFinished") private var autoMarkFinished: Bool = false
    
    @State private var isEditingName = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    headerCard

                    statsGrid

                    personalizationCard

                    // İleride buraya “Ayarlar” section’ları koyacağız.
                    // Örn: export, theme, backup, vs.
                }
                .padding()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Dışa Aktar (JSON)") {
                            exportBooks()
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
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

                    Text(readerTypeText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
    
    
    private var statsGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("İstatistikler")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                statTile(title: "Toplam", value: "\(totalCount)", systemImage: "books.vertical")
                statTile(title: "Okudum", value: "\(finishedCount)", systemImage: "checkmark.circle")
                statTile(title: "Okuyorum", value: "\(readingCount)", systemImage: "book")
                statTile(title: "İstek", value: "\(wishlistCount)", systemImage: "star")
                statTile(title: "Okunan Sayfa", value: "\(pagesReadTotal)", systemImage: "text.book.closed")
                statTile(title: "Yarım Bıraktım", value: "\(abandonedCount)", systemImage: "xmark.circle")
            }
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
    
    private var personalizationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kişiselleştirme")
                .font(.headline)

            Picker("Varsayılan görünüm", selection: $defaultLibraryLayout) {
                Text("Liste").tag("list")
                Text("Grid").tag("grid")
            }
            .pickerStyle(.segmented)

            Toggle(" %100 olunca otomatik 'Okudum' yap", isOn: $autoMarkFinished)

            Text("Bu ayarları birazdan Kütüphanem ekranına bağlayacağız.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
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
    
    private var readerTypeText: String {
        if finishedCount >= 20 { return "📚 Kitap Kurdu" }
        if finishedCount >= 5 { return "📘 Düzenli Okuyucu" }
        if finishedCount >= 1 { return "🌱 Başlangıç" }
        return "✨ Yeni Okur"
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
