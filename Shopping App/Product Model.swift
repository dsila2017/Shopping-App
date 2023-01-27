//
//  Product Model.swift
//  Shopping App
//
//  Created by David on 1/17/23.
//

import Foundation

struct ProductModel: Codable {
    
    var products: [productsArray]
}

struct productsArray: Codable, Hashable {
    
    var id: Int
    var title: String
    var description: String
    var price: Int
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String
    var category: String
    var thumbnail: String
    var images: [String]
}

