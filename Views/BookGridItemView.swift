//
//  BookGridItemView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 29.12.2025.
//

import SwiftUI

struct BookGridItemView: View {
    let book: Book
    
    var body: some View {
        VStack(spacing: 8) {
            if let name = book.coverImageName,
               let image = ImageStorage.loadImage(named: name) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 180)
                    .overlay(
                        Image(systemName: "book")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    )
            }
            
            Text(book.title).font(.subheadline).lineLimit(2).multilineTextAlignment(.center)
        }
    }
}
