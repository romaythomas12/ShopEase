//
//  MockUserDefaults.swift
//  ShopEase
//
//  Created by Thomas Romay on 07/11/2024.
//

import Foundation
@testable import ShopEase

class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]

    override func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }

    override func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
}
