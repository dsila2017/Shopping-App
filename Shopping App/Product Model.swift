//
//  Product Model.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import Foundation

struct ProductModel: Codable {
    
    let products: [productsArray]
}

struct productsArray: Codable, Hashable {
    
    let id: Int
    let title: String
    let description: String
    let price: Int
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}

