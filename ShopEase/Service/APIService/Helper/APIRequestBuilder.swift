//
//  APIRequestBuilder.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Foundation

class APIRequestBuilder {
    private let baseURL: String
    private let headers: [String: String]
    
    init(baseURL: String, headers: [String: String]) {
        self.baseURL = baseURL
        self.headers = headers
    }
    
    func buildRequest(with queryItems: [URLQueryItem], httpMethod: String = HTTPMethod.get.rawValue) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
