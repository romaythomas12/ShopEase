//
//  ProductListView.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import SwiftUI

struct ProductListView: View {
    let gradient = LinearGradient(colors: [Color.blue.opacity(0.6), Color.primaryColor],
                                  startPoint: .top, endPoint: .bottom)

    @StateObject private var viewModel = ProductListViewModel()
    private static let initialColumns = 2
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    var body: some View {
        ZStack {
            GradientBackgroundView()
            main
        }
        .navigationTitle("Products")
        .toolbarBackground(Color.blue.opacity(0.6), for: .navigationBar)
    }

    private var main: some View {
        VStack {
            switch viewModel.state {
                case .loading:
                    Spacer()
                    ProgressView("Loading Products...")
                        .tint(.white)
                        .bold()
                        .padding()
                        .foregroundStyle(.white)
                    Spacer()
                case .loaded:
                    content
                case .error(let message):
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
            }
        }.onAppear {
            viewModel.loadInitialProducts()
        }
    }

    private var content: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    VStack {
                        productList
                        loadingMoreProgress
                    }

                }.frame(maxWidth: .infinity,
                        minHeight: geometry.size.height,
                        alignment: .bottom)
            }
        }
    }

    private var productList: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(viewModel.products.indices, id: \.self) { index in
                let product = viewModel.products[index]
                NavigationLink(destination: ProductDetailsView(viewModel: ProductDetailsViewModel(productId: product.asin))
                    .toolbarRole(.editor)) {
                    ProductRow(product: product, isBookmarked: viewModel.bookmarkedStatus[product.id] ?? false)
                        .padding()
                }
                .onAppear {
                    Task {
                        await viewModel.loadMoreProductsIfNeeded(currentIndex: index)
                    }
                }
            }
        }
    }

    @ViewBuilder private var loadingMoreProgress: some View {
        if viewModel.isLoading {
            HStack {
                Spacer()
                ProgressView("Loading more...")
                    .foregroundStyle(Color.white)
                    .padding()
                    .tint(.white)
                    .bold()
                Spacer()
            }.frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ProductListView()
}
