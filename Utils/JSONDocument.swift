//
//  JSONDocument.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct JSONDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.json] }
    
    var fileURL: URL?
    
    init(fileURL: URL?) {
        self.fileURL = fileURL
    }
    
    init(configuration: ReadConfiguration) throws {
        fileURL = nil
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let fileURL else {
            throw CocoaError(.fileNoSuchFile)
        }
        let data = try Data(contentsOf: fileURL)
        return FileWrapper(regularFileWithContents: data)
    }
}
