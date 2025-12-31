//
//  GoogleBooksService.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 31.12.2025.
//

import Foundation

final class GoogleBooksService {
    static let shared = GoogleBooksService()
    
    private init() {}
    
    func fetchBook(isbn: String) async throws -> BookMetadata? {
        let query = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
        print("🌐 Request URL:", query)

        guard let url = URL(string: query) else {
            print("❌ URL oluşturulamadı")
            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        print("📦 Raw JSON:")
        print(String(data: data, encoding: .utf8) ?? "nil")

        let response = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)

        guard let item = response.items?.first else {
            print("⚠️ items boş")
            return nil
        }

        let info = item.volumeInfo

        return BookMetadata(
            title: info.title ?? "",
            author: info.authors?.first ?? "",
            pageCount: info.pageCount,
            thumbnailURL: URL(string: info.imageLinks?.thumbnail ?? "")
        )
    }

    
    struct GoogleBooksResponse: Decodable {
        let items: [GoogleBookItem]?
    }
    
    struct GoogleBookItem: Decodable {
        let volumeInfo: VolumeInfo
    }
    
    struct VolumeInfo: Decodable {
        let title: String?
        let authors: [String]?
        let pageCount: Int?
        let imageLinks: ImageLinks?
    }
    
    struct ImageLinks: Decodable {
        let thumbnail: String?
    }
    
}


