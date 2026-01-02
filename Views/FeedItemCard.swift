//
//  FeedItemCard.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI

struct FeedItemCard: View {
    
    let item: FeedItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(item.text)
                .font(.body)

            HStack(spacing: 6) {
                if let page = item.page {
                    Text("s. \(page)")
                }

                //kitap adi simdilik gosterilmiyor.
                if let page = item.page {
                    Text("s. \(page)")
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
        .contextMenu {
            Button {
                onEdit()
            } label: {
                Label("Düzenle", systemImage: "pencil")
            }

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Sil", systemImage: "trash")
            }
        }
        
    }
    
    
    
    
    
}
