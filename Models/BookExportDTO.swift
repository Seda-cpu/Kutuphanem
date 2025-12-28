//
//  BookExportDTO.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import Foundation

struct BookExportDTO: Codable {
    let title: String
    let author: String
    let isOwned: Bool
    let readingStatus: ReadingStatus
    let note: String?
    let coverImageName: String?
}
