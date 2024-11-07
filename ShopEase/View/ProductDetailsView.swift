//
//  ProductDetailsView.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import SwiftUI

// MARK: - View

struct ProductDetailsView: View {
    @StateObject var viewModel: ProductDetailsViewModel
    @State private var selectedPhotoIndex = 0

    var body: some View {
        ZStack {
            GradientBackgroundView()

            switch viewModel.state {
                case .loading:
                    ProgressView("Loading Product Details...")
                        .tint(.white)
                        .bold()
                        .foregroundStyle(.white)

                case .loaded(let product):
                    ProductDetailsContentView(product: product, viewModel: viewModel, selectedPhotoIndex: $selectedPhotoIndex)

                case .error(let message):
                    Text(message)
                        .foregroundStyle(.white)
                        .padding()
            }
        }
        .navigationTitle("Product Details")
        .toolbarBackground(Color.blue.opacity(0.6))
    }
}

// MARK: - Components

struct ProductDetailsContentView: View {
    let product: ProductDetail
    @ObservedObject var viewModel: ProductDetailsViewModel
    @Binding var selectedPhotoIndex: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                productPhotos

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 12) {
                        Text(product.productTitle)
                            .foregroundStyle(.white)
                            .font(.title3.weight(.semibold))

                        BookmarkButton(product: product, viewModel: viewModel)
                    }
                    if let price = product.formattedPrice {
                        Text(price)
                            .foregroundStyle(.white)
                            .font(.title3)
                    }
                    if let description = product.productDescription {
                        Text("About this product")
                            .foregroundStyle(.white)
                            .font(.title2.bold())
                            .padding(.bottom, 8)

                        ProductDescriptionView(productDescription: description)
                    }
                }
                .padding(20)
            }
            .padding(.top, 20)
        }
    }

    private var productPhotos: some View {
        TabView(selection: $selectedPhotoIndex) {
            ForEach(product.productPhotos.indices, id: \.self) { index in
                if let imgURL = product.productPhotos[index] {
                    AsyncImage(url: URL(string: imgURL)) { phase in
                        phase.image?
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
        .padding()
        .frame(height: 400)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct BookmarkButton: View {
    let product: ProductDetail
    @ObservedObject var viewModel: ProductDetailsViewModel

    var body: some View {
        Button(action: {
            viewModel.toggleBookmark(for: product)
        }) {
            Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ProductDetailsView(viewModel: ProductDetailsViewModel(productId: "B0D1ZFS9GH"))
}
