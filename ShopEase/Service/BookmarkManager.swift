//
//  BookmarkManager.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import Combine
import Foundation
protocol BookmarkManaging: ObservableObject {
    var bookmarkedProductIDs: Set<String> { get }
    var bookmarkedProductIDsPublisher: Published<Set<String>>.Publisher { get }
    
    func addBookmark(productID: String)
    func removeBookmark(productID: String)
    func isBookmarked(productID: String) -> Bool
    func toggleBookmark(productID: String)
}

class BookmarkManager: BookmarkManaging {
    static let shared = BookmarkManager(userDefaults: UserDefaults.standard)
    
    private let bookmarkedProductKey = "bookmarkedProductIDs"
    private let userDefaults: UserDefaults
    
    @Published private(set) var bookmarkedProductIDs: Set<String> = []
    
    var bookmarkedProductIDsPublisher: Published<Set<String>>.Publisher {
        $bookmarkedProductIDs
    }
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        loadBookmarks()
    }
    
    private func loadBookmarks() {
        if let savedData = userDefaults.object(forKey: bookmarkedProductKey) as? [String] {
            bookmarkedProductIDs = Set(savedData)
        }
    }
    
    private func saveBookmarks() {
        userDefaults.set(Array(bookmarkedProductIDs), forKey: bookmarkedProductKey)
    }
    
    func addBookmark(productID: String) {
        bookmarkedProductIDs.insert(productID)
        saveBookmarks()
    }
    
    func removeBookmark(productID: String) {
        bookmarkedProductIDs.remove(productID)
        saveBookmarks()
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
