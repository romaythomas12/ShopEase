//
//  ProductListViewModel.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class ProductListViewModel: ObservableObject {
    enum State {
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published private(set) var currentPage: Int = 1
    @Published private(set) var bookmarkedStatus: [String: Bool] = [:]
    @Published private(set) var state: State = .loading
    
    private let service: ProductServiceProtocol
    private let bookmarkManager: any BookmarkManaging
    private var cancellables: Set<AnyCancellable> = []

    init(service: any ProductServiceProtocol = ProductService(), bookmarkManager: any BookmarkManaging = BookmarkManager.shared) {
        self.service = service
        self.bookmarkManager = bookmarkManager
        
        setupObservers()
    }
    
    func loadInitialProducts() {
        guard products.isEmpty else { return }
        currentPage = 1
        loadProducts()
    }
    
    func loadProducts() {
        Task {
            await loadProductPage()
        }
    }
    
    private func setupObservers() {
        bookmarkManager.bookmarkedProductIDsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bookmarkedIDs in
                self?.updateBookmarkedStatus(bookmarkedIDs: bookmarkedIDs)
            }
            .store(in: &cancellables)
    }

    private func loadProductPage() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let fetchedProducts = try await service.fetchProductList(query: "Phone", page: currentPage)
            if currentPage == 1 {
                products = fetchedProducts
            } else {
                products.append(contentsOf: fetchedProducts)
            }
            self.state = .loaded
            currentPage += 1
            updateBookmarkedStatus(bookmarkedIDs: bookmarkManager.bookmarkedProductIDs)
            
        } catch {
            self.state = .error("Failed to load product.")
        }
        
        isLoading = false
    }
    
    private func updateBookmarkedStatus(bookmarkedIDs: Set<String>) {
        bookmarkedStatus = products.reduce(into: [:]) { statusDict, product in
            statusDict[product.id] = bookmarkedIDs.contains(product.id)
        }
    }
    
    func toggleBookmark(for productID: String) {
        bookmarkManager.toggleBookmark(productID: productID)
    }

    func loadMoreProductsIfNeeded(currentIndex: Int) async {
        guard currentIndex == products.count - 1, !isLoading else { return }
        loadProducts()
    }
}
