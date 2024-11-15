//
//  MockImageCache.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//

import Combine
@testable import ShopEase
import XCTest

// Mock classes
class MockImageCache: ImageCaching {
    var cache = [String: UIImage]()

    func image(forKey key: String) async -> UIImage? {
        return cache[key]
    }

    func setImage(_ image: UIImage, forKey key: String) async {
        cache[key] = image
    }
}

class MockDataLoader: DataLoading {
    var imageData: Data?
    var shouldThrowError = false

    func loadData(from url: URL) async throws -> (Data, URLResponse) {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: imageData?.count ?? 0, textEncodingName: nil)
        return (imageData ?? Data(), response)
    }
}
