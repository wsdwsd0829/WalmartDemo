//
//  Product.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import Foundation

struct Product {
    let productId: String
    let name: String
    let price: String
    let shortDescription: String
    let longDescription: String
    let imageUrl: String?
    let reviewRating: Double
    let reviewCount: Int
    let inStock: Bool
}
