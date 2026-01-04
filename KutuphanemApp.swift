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
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView(showSplash: $showSplash)
            }else {
                ContentView()
            }
            
        }
        .modelContainer(for: [Book.self, FeedItem.self])
    }
}
