//
//  NetworkManager.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import Foundation

//MARK: Errors
protocol ErrorDisplayable {
    var description: String? { get }
}
enum NetworkError: Error {
    case offline
    case nodata
}

extension NetworkError: ErrorDisplayable {
    var description: String? {
        switch self {
        case .offline: return "The Internet connection appears to be offline."
        case .nodata: return nil
        }
    }
}
typealias ProductHandler = ([Product]?, Error?) -> Void
typealias ImageHandler = (Data?, Error?) -> Void

//MARK: Network
class NetworkManager {
    let session = URLSession.shared
    let parser = Parser()
    
    fileprivate var isFetching: Bool = false
    
}

extension NetworkManager {
    private struct Constants {
        static let host = "https://walmartlabs-test.appspot.com/_ah/api/walmart/v1"
        static let key = "142b6009-4255-4711-8710-da8b2aafc00a"
    }
    private enum API: String {
        case products = "/walmartproducts/"
    }
    
    func queryUrl(pageNumber: UInt, pageSize: UInt) -> String {
        return Constants.host + API.products.rawValue + Constants.key + "/\(pageNumber)/\(pageSize)"
    }
    
    func fetchProducts(pageNumber: UInt, pageSize: UInt, handler: @escaping ([Product]?, Error?) -> Void) {
        let query = queryUrl(pageNumber: pageNumber, pageSize: pageSize)
        guard let queryURL = URL(string: query) else { fatalError("fail to create product url") }
        let task = session.dataTask(with: queryURL) { data, response, error in
            self.isFetching = false
            if let _ = error?.localizedDescription {
                handler(nil, NetworkError.offline)
                return
            }
            guard let data = data else { fatalError("no data")}
            self.parser.parseProducts(data: data) { products, error in
                if let error = error {
                    handler(nil, error)
                }
                if let products = products {
                    handler(products, nil)
                }
            }
        }
        isFetching = true
        task.resume()
    }
    
    func fetchImage(url: URL, handler: @escaping ImageHandler) {
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                handler(data, nil)
            }
        }
        dataTask.resume()
    }
    
    func isFetchingData() -> Bool {
        return isFetching
    }
}
