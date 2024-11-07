//
//  File.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//

import SwiftUI
extension View {
    func applyCardView(withShadow: Bool = true, padding: CGFloat = 16) -> some View {
        self.frame(maxWidth: .infinity)
            .padding(padding)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(withShadow ? 0.1 : 0), radius: 15, x: 0, y: 6)
    }

    func applyCardOverlay() -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
        )
    }
}
