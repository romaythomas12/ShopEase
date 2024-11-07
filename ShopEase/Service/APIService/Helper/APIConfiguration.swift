//
//  APIConfiguration.swift
//  ShopEase
//
//  Created by Thomas Romay on 06/11/2024.
//
import Foundation

enum APIConfiguration {
    static let headers: [String: String] = [
        "x-rapidapi-key": "YOUR_API_KEY_HERE",
        "x-rapidapi-host": "real-time-amazon-data.p.rapidapi.com"
    ]
    
    static let baseSearchURL = "https://real-time-amazon-data.p.rapidapi.com/search"
    static let baseDetailsURL = "https://real-time-amazon-data.p.rapidapi.com/product-details"
}
