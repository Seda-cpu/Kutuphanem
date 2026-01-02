//
//  FeedItem.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//
import Foundation
import SwiftData

@Model
class FeedItem {

    enum Kind: String, Codable {
        case quote
        case review
    }

    var kind: Kind
    var text: String
    var page: Int?
    var book: Book?
    var createdAt: Date

    init(
        kind: Kind,
        text: String,
        page: Int? = nil,
        book: Book? = nil,
        createdAt: Date = .now
    ) {
        self.kind = kind
        self.text = text
        self.page = page
        self.book = book
        self.createdAt = createdAt
    }
}
