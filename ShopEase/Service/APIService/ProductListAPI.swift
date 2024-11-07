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
    private let session: URLSession
    private let requestBuilder: APIRequestBuilder

    init(session: URLSession = .shared) {
        self.session = session
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
        let data = try await performRequest(request: request)
        return try decodeResponse(ProductListResponse.self, from: data).data.products
    }

    // MARK: - Helper Methods

    private func performRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }

    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
