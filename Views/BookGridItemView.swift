//
//  BookGridItemView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 29.12.2025.
//


import SwiftUI

struct BookGridItemView: View {
    let book: Book

    private let accentPink = Color(red: 0.95, green: 0.3, blue: 0.55)
    private let accentOrange = Color(red: 1.0, green: 0.55, blue: 0.2)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // 📕 KAPAK ALANI (GERÇEK RESİM VARSA KULLAN)
            ZStack {
                if let name = book.coverImageName,
                   let image = ImageStorage.loadImage(named: name) {
                    
                   
                        
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 110)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    

                } else {
                    // Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        accentPink.opacity(0.18),
                                        accentOrange.opacity(0.16)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        Image(systemName: "book")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [accentPink, accentOrange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }
            }
            .frame(height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // METİN ALANI
            VStack(alignment: .leading, spacing: 4) {

                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Spacer()

                Text(book.ReadingStatus.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: [accentPink, accentOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
        }
        .padding(12)
        .frame(height: 230) // 🔒 Tüm kartlar eşit
        .frame(maxWidth: .infinity, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.06))
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}
