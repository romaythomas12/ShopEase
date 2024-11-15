//
//  MockNetworkSession.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//

@testable import ShopEase
import XCTest

final class MockNetworkSession: NetworkSession {
    let mockData: Data?
    let mockResponse: URLResponse?
    let mockError: Error?

    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }

        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badServerResponse)
        }

        return (data, response)
    }
}
