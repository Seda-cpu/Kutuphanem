import SwiftUI

struct BookRowView: View {
    
    let book: Book
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Kapak placeholder
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                
                Text(book.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(book.ReadingStatus.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 4)
    }
}

