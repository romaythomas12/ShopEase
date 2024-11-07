//
//  ProductDetailsViewModel.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import Combine
import SwiftUI

@MainActor
class ProductDetailsViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(ProductDetail)
        case error(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var isBookmarked: Bool = false

    private let service: any ProductServiceProtocol
    private let bookmarkManager: any BookmarkManaging
    private let productId: String
    private var cancellables: Set<AnyCancellable> = []

    init(service: any ProductServiceProtocol = ProductService(),
         bookmarkManager: any BookmarkManaging = BookmarkManager.shared,
         productId: String) {
        self.service = service
        self.bookmarkManager = bookmarkManager
        self.productId = productId
        self.setuo()
    }

    private func setuo() {
        setupBindings()
        Task {
            await loadProductDetails()
        }
    }

    private func setupBindings() {
        bookmarkManager.bookmarkedProductIDsPublisher
            .receive(on: DispatchQueue.main)
            .map { [productId] in $0.contains(productId) }
            .assign(to: &$isBookmarked)
    }

    func loadProductDetails() async {
        state = .loading
        do {
            let product = try await service.fetchProductDetails(asin: productId)

            state = .loaded(product)
            isBookmarked = bookmarkManager.isBookmarked(productID: productId)

        } catch {
            state = .error("Failed to load product details.")
        }
    }

    func toggleBookmark(for product: ProductDetail) {
        bookmarkManager.toggleBookmark(productID: product.asin)
    }
}
