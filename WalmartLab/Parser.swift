//
//  Parser.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/24/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import Foundation
enum ParserError: Error {
    case noresults
    case format
}

extension ParserError: ErrorDisplayable {
    var description: String? {
        switch self {
        case .noresults: return nil
        case .format: return nil
        }
    }
}

class Parser {
    func parseProducts(data: Data, handler: ProductHandler) {
        guard let productsDict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
            fatalError("json format not correct") //fatalError should log to remote instead of crash in production
        }
        
        guard let productsArr = productsDict["products"] as? [[String: Any]] else {
            //TODO: try no results
            handler(nil, ParserError.noresults)
            return
        }
        
        var products = [Product]()
        productsArr.forEach {
            guard let productId = $0["productId"] as? String,
                let name = $0["productName"] as? String,
                let price = $0["price"] as? String else {
                    fatalError("missing mandatory field")
            }
            let shortDesc = $0["shortDescription"] as? String ?? ""
            let longDesc = $0["longDescription"] as? String ?? ""
            let imageUrl = $0["productImage"] as? String
            let rating = $0["reviewRating"] as? Double ?? 0.0
            let count = $0["reviewCount"] as? Int ?? 0
            let inStock = $0["inStock"] as? Bool ?? false
            
            let prod = Product(productId: productId, name: name, price: price, shortDescription: shortDesc, longDescription: longDesc, imageUrl: imageUrl, reviewRating: rating, reviewCount: count, inStock: inStock)
            
            products.append(prod)
        }
        
        handler(products, nil)
    }
}
