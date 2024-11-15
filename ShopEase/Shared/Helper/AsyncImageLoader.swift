//
//  AsyncImageLoader.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Foundation
import SwiftUI

@MainActor
class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?

    private let dataLoader: DataLoading
    private let imageCache: ImageCaching

    init(dataLoader: DataLoading = URLSession.shared,
         imageCache: ImageCaching = ImageCache.shared) {
        self.dataLoader = dataLoader
        self.imageCache = imageCache
    }

    func loadImage(from url: URL) async {
        self.url = url

        // Check if the image is cached
        if let cachedImage = await imageCache.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // Download image and cache it
        do {
            let (data, _) = try await dataLoader.loadData(from: url)
            guard let downloadedImage = UIImage(data: data) else { return }

            self.image = downloadedImage
            await imageCache.setImage(downloadedImage, forKey: url.absoluteString)
        } catch {
            print("Failed to load image:", error)
        }
    }

    func cancelLoading() {
        self.image = nil
    }
}
