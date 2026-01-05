//
//  ShareSheet.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 5.01.2026.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {

    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
