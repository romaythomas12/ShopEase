//
//  GradientBackgroundView.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//

import SwiftUI
struct GradientBackgroundView: View {
    let colors = [Color.blue.opacity(0.6), Color.primaryColor]
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
        .opacity(0.9)
        .ignoresSafeArea()
    }
}
