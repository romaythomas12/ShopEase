//
//  MockBookmarkManager.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//

import Combine
import Foundation
@testable import ShopEase

class MockBookmarkManager: BookmarkManaging {
    @Published private(set) var bookmarkedProductIDs: Set<String> = []

    var bookmarkedProductIDsPublisher: Published<Set<String>>.Publisher {
        $bookmarkedProductIDs
    }

    func addBookmark(productID: String) {
        bookmarkedProductIDs.insert(productID)
    }

    func removeBookmark(productID: String) {
        bookmarkedProductIDs.remove(productID)
    }

    func isBookmarked(productID: String) -> Bool {
        bookmarkedProductIDs.contains(productID)
    }

    func toggleBookmark(productID: String) {
        if isBookmarked(productID: productID) {
            removeBookmark(productID: productID)
        } else {
            addBookmark(productID: productID)
        }
    }
}
