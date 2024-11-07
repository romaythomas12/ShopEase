//
//  ProductDetailsViewModelTests.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Combine
import Foundation
@testable import ShopEase
import Testing

@MainActor
final class ProductDetailsViewModelTests {
    private var bookmarkManager: MockBookmarkManager!
    private var cancellables: Set<AnyCancellable> = []
    
    // Helper function to create the System Under Test (SUT)
    private func makeSUT(
        productId: String = "testID",
        service: MockProductService = MockProductService(),
        bookmarkManager: MockBookmarkManager = MockBookmarkManager()
    ) -> ProductDetailsViewModel {
        let viewModel = ProductDetailsViewModel(
            service: service,
            bookmarkManager: bookmarkManager,
            productId: productId
        )
        return viewModel
    }
    
    @Test func testLoadProductDetails_Success() async {
        // Arrange
        let viewModel = makeSUT()
        
        // Act
        viewModel.$state
            .dropFirst() // Skip initial loading state
            .sink { state in
                // Assert
                if case .loaded(let product) = state {
                    #expect(product.asin == "test01")
                    #expect(product.productTitle == "testTitle")
                }
            }.store(in: &cancellables)
        
        // Trigger the load
        await viewModel.loadProductDetails()
    }
    
    @Test func testToggleBookmark_AddAndRemove() {
        // Arrange
        let viewModel = makeSUT()
        
        // Act & Assert: Initial state should not be bookmarked
        #expect(viewModel.isBookmarked == false)
        
        // Toggle bookmark to add
        viewModel.toggleBookmark(for: MockProductService.mockProduct)
        
        viewModel.$isBookmarked
            .dropFirst() // Skip initial loading state
            .sink { _ in
                #expect(viewModel.isBookmarked == true)
            }
            .store(in: &cancellables)
       
        // Toggle bookmark to remove
        viewModel.toggleBookmark(for: MockProductService.mockProduct)
        #expect(viewModel.isBookmarked == false)
    }
}
