//
//  NetworkServiceProtocol.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//

import Foundation

protocol NetworkServiceProtocol {
    var session: NetworkSession { get }
}

final class NetworkService: NetworkServiceProtocol {
    let session: NetworkSession

    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension NetworkServiceProtocol {
    func performRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }

    func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
