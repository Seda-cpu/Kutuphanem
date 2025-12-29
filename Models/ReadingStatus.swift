//
//  ReadingStatus.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import Foundation

enum ReadingStatus: String, CaseIterable, Identifiable, Codable {
    case toRead = "Okuyacağım"
    case reading = "Okuyorum"
    case finished = "Okudum"
    case abandoned = "Yarım bıraktım"
    
    var id: String { rawValue }
}
