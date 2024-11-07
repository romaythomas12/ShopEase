//
//  MockProductService.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Foundation
@testable import ShopEase

class MockProductService: ProductServiceProtocol {
    static let mockProduct = ProductDetail(productTitle: "testTitle",
                                           currency: "USD",
                                           productPhotos: [],
                                           productPhoto: "",
                                           asin: "test01",
                                           productPrice: "99.99",
                                           productDescription: "This is a nice product")

    func fetchProductDetails(asin: String) async throws -> ProductDetail {
        return MockProductService.mockProduct
    }

    func fetchProductList(query: String, page: Int) async throws -> [Product] {
        return (1 ... 10).map { index in
            Product(productPrice: "\(Double(index) * 10)",
                    asin: "\(index)",
                    productTitle: "test\(index)",
                    currency: .usd,
                    productPhoto: "")
        }
    }
}
