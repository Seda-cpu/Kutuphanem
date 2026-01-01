//
//  ContentView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 28.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            LibraryView().tabItem{
                Label("Kütüphanem", systemImage: "books.vertical")
            }
            
            WishlistView().tabItem{
                Label("İstek Listem", systemImage: "star")
            }
            
            ProfileView().tabItem{
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}
