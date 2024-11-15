//
//  NetworkSession.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//

import Foundation

protocol NetworkSession: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol DataLoading {
    func loadData(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSession {}

extension URLSession: DataLoading {
    func loadData(from url: URL) async throws -> (Data, URLResponse) {
        return try await data(from: url)
    }
}
