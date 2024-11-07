//
//  BookmarkManagerTests.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//

@testable import ShopEase
import XCTest
class BookmarkManagerTests: XCTestCase {
    private var viewModel: BookmarkManager!
    private var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        viewModel = BookmarkManager(userDefaults: mockUserDefaults)
    }
    
    func testAddBookmark() {
        let productID = "testProduct1"
        
        viewModel.addBookmark(productID: productID)
        
        XCTAssertTrue(viewModel.isBookmarked(productID: productID))
        XCTAssertEqual(mockUserDefaults.object(forKey: "bookmarkedProductIDs") as? [String], [productID])
    }
    
    func testRemoveBookmark() {
        let productID = "testProduct1"
        viewModel.addBookmark(productID: productID)
        
        viewModel.removeBookmark(productID: productID)
        
        XCTAssertFalse(viewModel.isBookmarked(productID: productID))
        XCTAssertEqual(mockUserDefaults.object(forKey: "bookmarkedProductIDs") as? [String], [])
    }
}
