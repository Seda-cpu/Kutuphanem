//
//  KutuphanemApp.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI
import SwiftData


@main
struct KutuphanemApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Book.self, FeedItem.self])
    }
}
