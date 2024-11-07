//
//  ProductRow.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import SwiftUI
struct ProductRow: View {
    let product: Product
    let isBookmarked: Bool
    @StateObject private var imageLoader = AsyncImageLoader()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                // Placeholder while loading
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
            }
            
            VStack(alignment: .leading) {
                Text(product.productTitle)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                
                if let price = product.productPrice {
                    Text(price)
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.black)
            
            Spacer()
            
            if isBookmarked {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.blue)
            }
        }
        .applyCardView(withShadow: true)
        .task {
            if let url = URL(string: product.productPhoto) {
                await imageLoader.loadImage(from: url)
            }
        }
        .onDisappear {
            imageLoader.cancelLoading()
        }
    }
}
