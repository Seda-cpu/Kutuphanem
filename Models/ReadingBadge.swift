//
//  ReadingBadge.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import Foundation

enum ReadingBadge: Identifiable {
    case newReader
    case warmingUp
    case regularReader
    case bookFriend
    case bookWorm
    case wiseReader
    
    var id: String {title}
    
    var title: String {
        switch self {
        case .newReader: return "Yeni Okur"
        case .warmingUp: return "Başlangıç Okur"
        case .regularReader: return "Düzenli Okur"
        case .bookFriend: return "Kitap Dostu"
        case .bookWorm: return "Kitap Kurdu"
        case .wiseReader: return "Bilge Okur"
        }
    }
    
    var emoji: String {
        switch self {
            case .newReader: return "🌱"
            case .warmingUp: return "📘"
            case .regularReader: return "📗"
            case .bookFriend: return "📕"
            case .bookWorm: return "📚"
            case .wiseReader: return "🧠"
        }
    }
    
    var pageRangeText: String {
        switch self {
            case .newReader: return "0–100 sayfa"
            case .warmingUp: return "100–500 sayfa"
            case .regularReader: return "500–1500 sayfa"
            case .bookFriend: return "1500–3000 sayfa"
            case .bookWorm: return "3000–6000 sayfa"
            case .wiseReader: return "6000+ sayfa"
        }
    }
    
    static func badge(for totalPagesRead: Int) -> ReadingBadge {
        switch totalPagesRead {
        case 0..<100:
            return .newReader
        case 100..<500:
            return .warmingUp
        case 500..<1500:
            return .regularReader
        case 1500..<3000:
            return .bookFriend
        case 3000..<6000:
            return .bookWorm
        default:
            return .wiseReader
        }
    }
    
    
    
    
}
