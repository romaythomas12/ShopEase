//
//  AsyncImageLoaderTests.swift
//  ShopEase
//
//  Created by Thomas Romay on 15/11/2024.
//
@testable import ShopEase
import XCTest

@MainActor
class AsyncImageLoaderTests: XCTestCase {
    var imageLoader: AsyncImageLoader!
    var mockCache: MockImageCache!
    var mockDataLoader: MockDataLoader!

    override func setUp() {
        super.setUp()
        mockCache = MockImageCache()
        mockDataLoader = MockDataLoader()
        imageLoader =  AsyncImageLoader(dataLoader: mockDataLoader, imageCache: mockCache)
       
    }

    func testLoadImageFromNetwork() async {
        let testURL = URL(string: "https://example.com/image.png")!
        mockDataLoader.imageData = UIImage(systemName: "photo")!.pngData()

        await imageLoader.loadImage(from: testURL)

        XCTAssertNotNil(imageLoader.image)
        XCTAssertEqual(mockCache.cache[testURL.absoluteString], imageLoader.image)
    }

    func testLoadImageFromCache() async {
        let testURL = URL(string: "https://example.com/image.png")!
        let cachedImage = UIImage(systemName: "star")!
        await mockCache.setImage(cachedImage, forKey: testURL.absoluteString)

        await imageLoader.loadImage(from: testURL)

        XCTAssertEqual(imageLoader.image, cachedImage)
    }

    func testLoadImageErrorHandling() async {
        let testURL = URL(string: "https://example.com/image.png")!
        mockDataLoader.shouldThrowError = true

        await imageLoader.loadImage(from: testURL)

        XCTAssertNil(imageLoader.image)
    }
}
