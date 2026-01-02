import SwiftUI
import SwiftData

struct AddFeedItemView: View {

    let kind: FeedItem.Kind

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var books: [Book]

    @State private var selectedBook: Book?
    @State private var text: String = ""
    @State private var pageText: String = ""
    @State private var showBookPicker = false
    
   
    
    var body: some View {
        NavigationStack {
            Form {

                Section("Kitap") {
                    Button {
                        showBookPicker = true
                    } label: {
                        HStack {
                            Text(selectedBook?.title ?? "Kitap Seç")
                                .foregroundColor(selectedBook == nil ? .secondary : .primary)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section(kind == .quote ? "Alıntı" : "İnceleme") {
                    TextEditor(text: $text)
                        .frame(minHeight: 120)
                }

                if kind == .quote {
                    Section("Sayfa") {
                        TextField("Örn: 78", text: $pageText)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationTitle(kind == .quote ? "Alıntı Ekle" : "İnceleme Ekle")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kaydet") {
                        save()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .sheet(isPresented: $showBookPicker) {
                BookPickerView(selectedBook: $selectedBook)
            }
        }
    }

    private func save() {
        let item = FeedItem(
            kind: kind,
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            page: kind == .quote ? Int(pageText) : nil,
            book: selectedBook
        )
        
        item.bookTitle = selectedBook?.title
        
        modelContext.insert(item)
        dismiss()
    }
}
