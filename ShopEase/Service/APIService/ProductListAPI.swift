//
//  ProductListAPIProtocol.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//
import Foundation

// MARK: - Product List API

protocol ProductListAPIProtocol {
    func fetchProductList(query: String, page: Int) async throws -> [Product]
}

final class ProductListAPI: ProductListAPIProtocol {
    private let networkService: NetworkServiceProtocol
    private let requestBuilder: APIRequestBuilder
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.requestBuilder = APIRequestBuilder(baseURL: APIConfiguration.baseSearchURL, headers: APIConfiguration.headers)
    }

    func fetchProductList(query: String, page: Int) async throws -> [Product] {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "country", value: "US"),
            URLQueryItem(name: "sort_by", value: "RELEVANCE"),
            URLQueryItem(name: "product_condition", value: "ALL"),
            URLQueryItem(name: "is_prime", value: "false"),
            URLQueryItem(name: "deals_and_discounts", value: "NONE")
        ]

        let request = try requestBuilder.buildRequest(with: queryItems)
        let data = try await networkService.performRequest(request: request)
        return try networkService.decodeResponse(ProductListResponse.self, from: data).data.products
    }
}
