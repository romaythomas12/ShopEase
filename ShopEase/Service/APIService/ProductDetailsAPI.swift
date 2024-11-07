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
    private let session: URLSession
    private let requestBuilder: APIRequestBuilder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.requestBuilder = APIRequestBuilder(baseURL: APIConfiguration.baseDetailsURL, headers: APIConfiguration.headers)
    }
    
    func fetchProductDetails(asin: String) async throws -> ProductDetail {
        let queryItems = [
            URLQueryItem(name: "asin", value: asin),
            URLQueryItem(name: "country", value: "US")
        ]
        
        let request = try requestBuilder.buildRequest(with: queryItems)
        let data = try await performRequest(request: request)
        return try decodeResponse(ProductDetailResponse.self, from: data).data
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
