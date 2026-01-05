//
//  NotificationFrequency.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 5.01.2026.
//

import Foundation

enum NotificationFrequency: String, CaseIterable, Identifiable, Codable {
    case none = "Kapalı"
    case daily = "Günlük"
    case weekly = "Haftalık"

    var id: String { rawValue }
}
