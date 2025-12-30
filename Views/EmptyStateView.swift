//
//  EmptyStateView.swift
//  Kutuphanem
//
//  Created by Sedanur Kırcı on 30.12.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon).font(.system(size: 48)).foregroundColor(.secondary)
            
            Text(title).font(.title3).fontWeight(.semibold)
            
            Text(message).font(.body).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal, 32)
            
            if let action {
                Button(actionTitle) {
                    action()
                }
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
