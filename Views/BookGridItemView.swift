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

            ZStack(alignment: .topTrailing) {
                coverView
                    .frame(height: 180)
                    .cornerRadius(12)

                statusBadge
                    .padding(8)
            }

            Text(book.title)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Cover
    @ViewBuilder
    private var coverView: some View {
        if let name = book.coverImageName,
           let image = ImageStorage.loadImage(named: name) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "book")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                )
        }
    }

    // MARK: - Badge
    private var statusBadge: some View {
        Image(systemName: book.ReadingStatus.badgeIcon)
            .font(.caption.weight(.bold))
            .foregroundColor(.white)
            .padding(6)
            .background(
                Circle().fill(book.ReadingStatus.badgeColor)
            )
            .accessibilityLabel(book.ReadingStatus.rawValue)
    }
}
