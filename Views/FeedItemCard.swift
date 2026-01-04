import SwiftUI

struct FeedItemCard: View {

    let item: FeedItem
    let onEdit: () -> Void
    let onDelete: () -> Void

    // İkon paleti
    private let accentPink = Color(red: 0.95, green: 0.3, blue: 0.55)
    private let accentOrange = Color(red: 1.0, green: 0.55, blue: 0.2)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(item.text)
                .font(.body)
                .foregroundColor(.primary)

            HStack(spacing: 6) {
                if let page = item.page {
                    Text("s. \(page)")
                }

                if let title = item.bookTitle, !title.isEmpty {
                    Text("· \(title)")
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
            ZStack(alignment: .leading) {

                // Kart yüzeyi
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))

                // Sol accent çizgi (çok ince)
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentPink.opacity(0.35),
                                accentOrange.opacity(0.35)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 3)
            }
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
