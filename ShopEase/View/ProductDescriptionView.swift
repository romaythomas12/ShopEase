//
//  ProductDescriptionView.swift
//  ShopEase
//
//  Created by Thomas Romay on 03/11/2024.
//

import SwiftUI
struct ProductDescriptionView: View {
    let productDescription: String

    @State private var isTruncated = false
    private let maxLineHeight: CGFloat = 20
    private let maxLines = 3

    var body: some View {
        VStack(alignment: .leading) {
            Text(productDescription)
                .foregroundStyle(.white)
                .font(.body)
                .lineLimit(isTruncated ? maxLines : nil) // Apply line limit only when text is truncated
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        let lineHeight = maxLineHeight
                        let totalHeight = geometry.size.height
                        let requiredLines = totalHeight / lineHeight

                        // Check if the text exceeds the specified number of lines
                        isTruncated = requiredLines > CGFloat(maxLines)
                    }
                })

            if isTruncated {
                NavigationLink {
                    ZStack {
                        GradientBackgroundView()
                        ScrollView {
                            Text(productDescription)
                                .font(.body)
                                .padding(20)
                        }
                        .background(.white)
                        .cornerRadius(10)
                        .padding(20)

                    }.toolbarRole(.editor)
                } label: {
                    HStack {
                        Spacer()
                        Label("More details", systemImage: "chevron.down")
                            .foregroundStyle(.white)
                            .font(.body)
                    }
                }
            }
        }
    }
}

#Preview {
    ProductDescriptionView(productDescription: "This is a sample product description.")
}
