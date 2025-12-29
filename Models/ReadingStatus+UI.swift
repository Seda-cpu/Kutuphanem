//
//  ReadingStatus+UI.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 29.12.2025.
//

import SwiftUI

extension ReadingStatus {
    
    var badgeColor: Color {
        switch self {
        case .toRead: return .gray
        case .reading: return .blue
        case .finished: return .green
        case .abandoned: return .orange
            
        }
    }
    
    var badgeIcon: String {
        switch self {
        case .toRead:     return "bookmark"
        case .reading:    return "book"
        case .finished:   return "checkmark"
        case .abandoned:  return "xmark"
        }
    }
}
