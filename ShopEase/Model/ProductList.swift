//
//  ProductList.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import Foundation
struct ProductListResponse: Codable, Sendable {
    let status: String
    let data: ProductList
    let requestID: String
    
    enum CodingKeys: String, CodingKey {
        case status, data
        case requestID = "request_id"
    }
}

// MARK: - DataClass

struct ProductList: Codable, Sendable {
    let products: [Product]
    let country, domain: String
    let totalProducts: Int
    
    enum CodingKeys: String, CodingKey {
        case products, country, domain
        case totalProducts = "total_products"
    }
}

// MARK: - Product

struct Product: Codable, Sendable {
    let productPrice: String?
    let asin, productTitle: String
    let currency: Currency?
    let productPhoto: String
    
    enum CodingKeys: String, CodingKey {
        case productPrice = "product_price"
        case asin
        case productTitle = "product_title"
        case currency
        case productPhoto = "product_photo"
    }
}

enum Currency: String, Codable, Sendable {
    case usd = "USD"
}

extension Product: Identifiable, Hashable {
    public var id: String { asin }
}
