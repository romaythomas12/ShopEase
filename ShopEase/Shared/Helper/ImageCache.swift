//
//  ImageCache.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import UIKit

protocol ImageCaching {
    func image(forKey key: String) async -> UIImage?
    func setImage(_ image: UIImage, forKey key: String) async
}

actor ImageCache: ImageCaching {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
