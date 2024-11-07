//
//  ProductDetail.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Foundation

// MARK: - ProductDetail

struct ProductDetailResponse: Codable, Sendable {
    let status: String
    let data: ProductDetail
    let requestID: String

    enum CodingKeys: String, CodingKey {
        case status, data
        case requestID = "request_id"
    }
}

struct ProductDetail: Codable, Sendable {
    let productTitle: String
    let currency: String?
    let productPhotos: [String?]
    let productPhoto: String
    let asin, productPrice: String
    let productDescription: String?

    enum CodingKeys: String, CodingKey {
        case productTitle = "product_title"
        case currency
        case productPhotos = "product_photos"
        case productPhoto = "product_photo"
        case asin
        case productPrice = "product_price"
        case productDescription = "product_description"
    }
}

extension ProductDetail {
    var formattedPrice: String? {
        if let currency {
            return "\(CurrencyCode(rawValue: currency)?.symbol ?? CurrencyCode.USD.symbol)\(self.productPrice)"
        } else {
            return nil
        }
    }
}

enum CurrencyCode: String {
    case GBP
    case USD

    var symbol: String {
        switch self {
            case .GBP:
                return "£"
            case .USD:
                return "$"
        }
    }
}
