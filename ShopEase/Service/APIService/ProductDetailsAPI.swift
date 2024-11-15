//
//  ProductDetailsAPI.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//
import Foundation

// MARK: - Product Details API

protocol ProductDetailsAPIProtocol {
    func fetchProductDetails(asin: String) async throws -> ProductDetail
}

final class ProductDetailsAPI: ProductDetailsAPIProtocol {
    private let networkService: NetworkServiceProtocol
    private let requestBuilder: APIRequestBuilder

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.requestBuilder = APIRequestBuilder(baseURL: APIConfiguration.baseSearchURL, headers: APIConfiguration.headers)
    }

    func fetchProductDetails(asin: String) async throws -> ProductDetail {
        let queryItems = [
            URLQueryItem(name: "asin", value: asin),
            URLQueryItem(name: "country", value: "US")
        ]

        let request = try requestBuilder.buildRequest(with: queryItems)
        let data = try await networkService.performRequest(request: request)
        return try networkService.decodeResponse(ProductDetailResponse.self, from: data).data
    }
}
