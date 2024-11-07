//
//  ProductService.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import Foundation

// MARK: - Product Service

protocol ProductServiceProtocol {
    func fetchProductList(query: String, page: Int) async throws -> [Product]
    func fetchProductDetails(asin: String) async throws -> ProductDetail
}

final class ProductService: ProductServiceProtocol {
    private let productListAPI: ProductListAPIProtocol
    private let productDetailsAPI: ProductDetailsAPIProtocol

    init(productListAPI: ProductListAPIProtocol = ProductListAPI(),
         productDetailsAPI: ProductDetailsAPIProtocol = ProductDetailsAPI()) {
        self.productListAPI = productListAPI
        self.productDetailsAPI = productDetailsAPI
    }

    func fetchProductList(query: String, page: Int) async throws -> [Product] {
        return try await productListAPI.fetchProductList(query: query, page: page)
    }

    func fetchProductDetails(asin: String) async throws -> ProductDetail {
        return try await productDetailsAPI.fetchProductDetails(asin: asin)
    }
}
