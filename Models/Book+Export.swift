//
//  Book+Export.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import Foundation

extension Book {
    func toExportDTO() -> BookExportDTO {
        BookExportDTO(
            title: title,
            author: author,
            isOwned: isOwned,
            readingStatus: ReadingStatus,
            note: note,
            coverImageName: coverImageName
        )
    }
}
