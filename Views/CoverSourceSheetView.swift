//
//  CoverSourceSheetView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 3.01.2026.
//

import SwiftUI

struct CoverSourceSheetView: View {

    let onGallery: () -> Void
    let onCamera: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {

            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Kapak Fotoğrafı")
                .font(.headline)
                .padding(.top, 8)

            Button {
                onGallery()
            } label: {
                actionRow(
                    icon: "photo.on.rectangle",
                    title: "Galeriden Seç"
                )
            }

            Button {
                onCamera()
            } label: {
                actionRow(
                    icon: "camera",
                    title: "Kamerayla Çek"
                )
            }

            Divider().padding(.vertical, 4)

            Button {
                onCancel()
            } label: {
                Text("Vazgeç")
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
        .presentationDetents([.height(260)])
        .presentationDragIndicator(.hidden)
    }

    private func actionRow(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)

            Text(title)
                .font(.body)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.opacity(0.1))
        )
    }
}
