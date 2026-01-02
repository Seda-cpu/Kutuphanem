//
//  ReadingBadgesView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 2.01.2026.
//

import SwiftUI

struct ReadingBadgesView: View {
    
    let currentBadge: ReadingBadge
    let totalPagesRead: Int
    
    var body: some View {
        NavigationStack {
            if let remaining = currentBadge.remainingPages(toReach: totalPagesRead) {
                nextBadgeInfoCard(remaining: remaining)
            }
            List {
                ForEach(allBadges) { badge in
                    HStack(spacing: 12) {

                        Text(badge.emoji)
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(badge.title)
                                .font(.headline)

                            Text(badge.pageRangeText)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if badge == currentBadge {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Okuma Rozetleri")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") {
                        dismiss()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    @Environment(\.dismiss) private var dismiss

    private var allBadges: [ReadingBadge] {
        [
            .newReader,
            .warmingUp,
            .regularReader,
            .bookFriend,
            .bookWorm,
            .wiseReader
        ]
    }
    
    private func nextBadgeInfoCard(remaining: Int) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "target")
                .foregroundColor(.blue)

            Text("Bir sonraki rozete **\(remaining) sayfa** kaldı")
                .font(.footnote)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal)
    }
}
