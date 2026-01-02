//
//  FeedItemCard.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI

struct FeedItemCard: View {
    
    let item: FeedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(item.text)
                .font(.body)

            HStack(spacing: 6) {
                if let page = item.page {
                    Text("s. \(page)")
                }

                if let book = item.book {
                    Text("· \(book.title)")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)

            Text(item.createdAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
        )
        
    }
}
