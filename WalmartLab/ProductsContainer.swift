//
//  ProductsContainer.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/18/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import Foundation
import UIKit

protocol ProductProvider {
    var products: [Product] { get }
    func fetchProducts(handler: @escaping ([Product]?, Error?) -> Void)
    func fetchImage(for url: String, handler: @escaping (UIImage?) -> Void)
}

class ProductsContainer: ProductProvider {
    struct Paginator {
        private(set) var pageNumber: UInt
        private(set) var pageSize: UInt
        private var totalPage: UInt
        
        mutating func setTotalPage(_ totalPage: UInt) {
            self.totalPage = totalPage
        }
        
        init(pageNumber: UInt, pageSize: UInt = 20, totalPage: UInt = UInt.max) {
            self.pageSize = pageSize
            self.pageNumber = pageNumber
            self.totalPage = totalPage
        }
        
        func next() -> Paginator {
            return Paginator(pageNumber: pageNumber+1)
        }
        
        func prev() -> Paginator {
            return Paginator(pageNumber: pageNumber >= 1 ? pageNumber : 0)
        }
    }

    static var shared = ProductsContainer()
    var paginator: Paginator
    var products: [Product]
    let networkManager: NetworkManager
    var cache = [String: UIImage]()
    
    init(networkManager: NetworkManager = NetworkManager(),
         products: [Product] = [Product](),
         paginator: Paginator = Paginator(pageNumber: 0)) {
        self.products = products
        self.paginator = paginator
        self.networkManager = networkManager
    }
    
    func add(prods: [Product]) {
        products += prods
    }
    
    func fetchProducts(handler: @escaping ([Product]?, Error?) -> Void) {
        networkManager.fetchProducts(pageNumber: paginator.pageNumber, pageSize: paginator.pageSize) { (prods, error) in
            DispatchQueue.main.async {
                if let prods = prods, prods.count > 0 {
                    ProductsContainer.shared.add(prods: prods)
                    ProductsContainer.shared.paginator = ProductsContainer.shared.paginator.next()
                }
                handler(prods, error)
            }
        }
    }
    
    func fetchImage(for url: String, handler: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else { return }
        if let cachedImage = cache[url] {
            DispatchQueue.main.async {
                handler(cachedImage)
            }
            return
        }
        
        networkManager.fetchImage(url: imageURL, handler: { (data, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache[url] = image
                    handler(image)
                }
            }
        })
    }
    
    func shouldPrefetch(at index: Int) -> Bool {
        let managerAvailable = !networkManager.isFetchingData()
        if !managerAvailable {
            print("manager not available")
        } else {
            print("pageNumber: \(paginator.pageNumber), at row: \(index)")
        }
        return managerAvailable && index + 3 > products.count
    }
}
