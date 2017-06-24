//
//  ProductPageViewController.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

class ProductPageViewController: UIPageViewController {
    var products: [Product] {
        return ProductsContainer.shared.products
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        dataSource = self
    }
}

extension ProductPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let detailController = viewController as? DetailViewController,
             let index = detailController.index else {
            return nil
        }
        
        let newIndex = index - 1
        guard newIndex >= 0 else { return nil }
        return createDetailViewController(product: products[newIndex], index: newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let detailController = viewController as? DetailViewController,
            let index = detailController.index else {
                return nil
        }
        
        let newIndex = index + 1
        guard newIndex < products.count else { return nil }
        
        loadNewPagesIfNeeded(for: newIndex)
        return createDetailViewController(product: products[newIndex], index: newIndex)
    }
    
    func loadNewPagesIfNeeded(for index: Int) {
        if ProductsContainer.shared.shouldPrefetch(at: index) {
            ProductsContainer.shared.fetchProducts(handler: {_, _ in
            })
        }
    }
    
    private func createDetailViewController(product: Product, index: Int) -> DetailViewController? {
        if let newDetailController: DetailViewController = Utils.createViewControllerFromStoryboard(identifier: DetailViewController.identifier) {
            newDetailController.product = product
            newDetailController.index = index
            return newDetailController
        }
        return nil
    }
}
