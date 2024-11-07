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

    func loadImage(from url: URL) async {
        self.url = url

        // Check if the image is cached
        if let cachedImage = await ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // Download image and cache it
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloadedImage = UIImage(data: data) else { return }

            self.image = downloadedImage
            await ImageCache.shared.setImage(downloadedImage, forKey: url.absoluteString)
        } catch {
            print("Failed to load image:", error)
        }
    }

    func cancelLoading() {
        self.image = nil
    }
}
