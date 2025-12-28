//
//  Book.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import Foundation
import SwiftData


@Model
class Book {
    var title: String
    var author: String

    var isOwned: Bool
    var ReadingStatus: ReadingStatus
    var note: String?
    var coverImageName: String?
    
    init(title: String, author: String, isOwned: Bool, readingStatus: ReadingStatus, note: String? = nil, coverImageName: String? = nil) {
        
        self.title = title
        self.author = author
        self.isOwned = isOwned
        self.ReadingStatus = readingStatus
        self.note = note
        self.coverImageName = coverImageName
    }
    
}




//struct Book: Identifiable {
//    var id: UUID
//    
//    var title: String
//    var author: String
//    
//    var isOwned: Bool
//    var ReadingStatus: ReadingStatus
//    var note: String?
//    var coverImageName: String?
//    
//    init(id: UUID = UUID(), title: String, author: String, isOwned: Bool, readingStatus: ReadingStatus, note: String? = nil, coverImageName: String? = nil) {
//        self.id = id
//        self.title = title
//        self.author = author
//        self.isOwned = isOwned
//        self.ReadingStatus = readingStatus
//        self.note = note
//        self.coverImageName = coverImageName
//    }
//}
