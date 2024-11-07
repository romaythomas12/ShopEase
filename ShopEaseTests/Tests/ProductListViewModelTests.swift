//
//  ProductListViewModelTests.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Combine
@testable import ShopEase
import Testing

final class ProductListViewModelTests {
    private var bookmarkManager: MockBookmarkManager!
    private var cancellables: Set<AnyCancellable> = []
    
    // Async helper function to create the SUT (System Under Test)
    private func makeSUT(
        bookmarkManager: MockBookmarkManager = MockBookmarkManager(),
        service: MockProductService = MockProductService()
    ) async -> ProductListViewModel {
        let viewModel = await ProductListViewModel(service: service, bookmarkManager: bookmarkManager)
        return viewModel
    }
    
    @MainActor
    @Test func testLoadInitialProducts() async {
        // Arrange
        let viewModel = await makeSUT()
        
        // Act
        viewModel.$products
            .dropFirst()
            .sink { products in
                // Assert
                #expect(products.count == 10)
                #expect(products.first?.productTitle == "Product 1")
            }
            .store(in: &cancellables)
        
        viewModel.loadInitialProducts()
        
    }
    
    @Test
    func testToggleBookmark_UpdatesBookmarkStatus() async throws {
        // Arrange
        let bookmarkManager = MockBookmarkManager()
        let viewModel = await makeSUT(bookmarkManager: bookmarkManager)
        let productID = "testID1"
        
        // Act: Toggle bookmark and observe changes
        
        var toggledState: Bool? // Track the last observed state
        
        await viewModel.$bookmarkedStatus
            .dropFirst() // Ignore the initial state
            .sink { status in
                if let currentState = status[productID] {
                    if toggledState == nil || toggledState == false {
                        // Assert - first toggle should set bookmarked to true
                        #expect(currentState == true)
                        toggledState = currentState
                    } else {
                        // Assert - second toggle should set bookmarked to false
                        #expect(currentState == false)
                    }
                }
            }
            .store(in: &cancellables)
        
        // First toggle
        await viewModel.toggleBookmark(for: productID)
        // Second toggle
        await viewModel.toggleBookmark(for: productID)
    }
}
