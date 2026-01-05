//
//  BookDetailView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//
import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct BookDetailView: View {
    
    @Bindable var book: Book
    @State private var selectedItem: PhotosPickerItem?
    @FocusState private var isPageFieldFocused: Bool
    @FocusState private var isPageCountFieldFocused: Bool
    @State private var isEditingPageCount = false
    @AppStorage("autoMarkFinished") private var autoMarkFinished: Bool = false
    @State private var showAddQuoteSheet = false
    @State private var showShareSheet = false
    
    private let accentPink = Color(red: 0.95, green: 0.3, blue: 0.55)
    private let accentOrange = Color(red: 1.0, green: 0.55, blue: 0.2)

    
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
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [accentPink, accentOrange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }
            }
            
            Section("Kitap Bilgileri") {
                Text(book.title)
                Text(book.author).foregroundColor(.secondary)
            }
            
            Section("Sayfa Bilgisi") {

                
                if isEditingPageCount {

                    TextField(
                        "Örn: 320",
                        text: Binding(
                            get: { book.pageCount.map(String.init) ?? "" },
                            set: { book.pageCount = Int($0) }
                        )
                    )
                    .keyboardType(.numberPad)
                    .focused($isPageCountFieldFocused)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(LinearGradient(
                                colors: [accentPink.opacity(0.6), accentOrange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isPageCountFieldFocused = true
                        }
                    }

                } else {

                    HStack {
                        Text("Toplam Sayfa")
                        Spacer()

                        if let pageCount = book.pageCount {
                            Text("\(pageCount)")
                                .foregroundColor(.primary)
                        } else {
                            Text("Belirtilmedi")
                                .foregroundColor(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isEditingPageCount = true
                    }
                }
                
            }
            
            Section("Okuma Durumu") {
                
                Picker("Durum", selection: $book.ReadingStatus) {
                    ForEach(ReadingStatus.allCases) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
            }
            
            if book.ReadingStatus == .reading {
                Section("Okuma İlerlemesi") {

                    if let pageCount = book.pageCount {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Kaçıncı sayfadasın?")
                                .font(.subheadline)

                            TextField("Örn: 135", text: Binding(
                                get: { book.currentPage.map(String.init) ?? "" },
                                set: { book.currentPage = Int($0)
                                    checkAutoMarkFinished()}
                            ))
                            .keyboardType(.numberPad)
                            .focused($isPageFieldFocused)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(LinearGradient(
                                        colors: [accentPink.opacity(0.6), accentOrange.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                            
                            Text("Toplam \(pageCount) sayfa")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            if let percent = book.readingProgressText {
                                ProgressView(value: book.readingProgress)
                                    .tint(
                                            LinearGradient(
                                                colors: [accentPink, accentOrange],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                Text(percent)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        Text("Okuma yüzdesi için önce toplam sayfa sayısını girmelisin.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Button {
                showAddQuoteSheet = true
            } label: {
                HStack {
                    Image(systemName: "quote.opening")
                    Text("Alıntı Ekle")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            accentPink.opacity(0.15),
                            accentOrange.opacity(0.15)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
            .buttonStyle(.plain)
            
            
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Bitti") {
                    isPageFieldFocused = false
                    isPageCountFieldFocused = false
                    isEditingPageCount = false
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showShareSheet = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(
            LinearGradient(
                colors: [
                    accentPink.opacity(0.06),
                    accentOrange.opacity(0.04)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            for: .navigationBar
        )
        .sheet(isPresented: $showAddQuoteSheet) {
            AddQuoteView(book: book)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [shareText])
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
                .fill(
                    LinearGradient(
                        colors: [
                            accentPink.opacity(0.15),
                            accentOrange.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Image(systemName: "book")
                        .font(.largeTitle)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentPink, accentOrange],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
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
    
    private func checkAutoMarkFinished() {
        guard autoMarkFinished else { return }
        guard book.ReadingStatus == .reading else { return }
        guard let progress = book.readingProgress else { return }

        if progress >= 1.0 {
            book.ReadingStatus = .finished
            book.finishedAt = Date()
        }
    }
  
    private var shareText: String {
        var text = "📚 Kitap Önerisi\n\n"
        text += book.title

        if !book.author.isEmpty {
            text += " – \(book.author)"
        }

        text += "\n\nBu kitabı Ayraç uygulamasında okuyorum."
        text += "\n📲 Uygulamayı indir:\n"
        text += "https://apps.apple.com/app/idXXXXXXXXX"

        return text
    }
}
