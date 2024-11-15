//
//  MockNetworkService.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//

@testable import ShopEase
import XCTest

class MockNetworkService: NetworkServiceProtocol {
    internal let session: NetworkSession

    init(session: MockNetworkSession = MockNetworkSession()) {
        self.session = session
    }

    var data: Data?
    var error: Error?

    func performRequest(request: URLRequest) async throws -> Data {
        if let error = error {
            throw error
        }
        return data ?? Data()
    }

    func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
