import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    
    // SwiftData
    @Query private var books: [Book]
    
    // Export state
    @State private var exportURL: URL?
    @State private var showExporter = false
    
    var body: some View {
        NavigationStack {
            Text("Kütüphane ayarları")
                .navigationTitle("Ayarlar")
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
    
    // MARK: - Export Logic
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
