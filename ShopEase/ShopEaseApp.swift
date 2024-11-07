//
//  ShopEaseApp.swift
//  ShopEase
//
//  Created by Thomas Romay on 02/11/2024.
//

import SwiftUI

@main
struct ShopEaseApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ProductListView()
            }
            .navigationViewStyle(.stack)
        }
    }
}
