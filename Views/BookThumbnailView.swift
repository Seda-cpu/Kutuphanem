//
//  BookThumbnailView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI

struct BookThumbnailView: View {

    let book: Book
    
    var body: some View {
        Group {
            if let image = loadCoverImage() {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: 36, height: 52)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.secondary.opacity(0.2))
        )
    }

    private func loadCoverImage() -> UIImage? {
        guard let name = book.coverImageName else { return nil }
        return ImageStorage.loadImage(named: name)
    }

    private var placeholder: some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: "book.closed")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
