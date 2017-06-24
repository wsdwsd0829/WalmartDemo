//
//  ViewController.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

/*
 TODO: 
 */

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var selectedIndex: Int?
    
    fileprivate let productProvider: ProductProvider = ProductsContainer.shared
    
    fileprivate var products: [Product] {
        return productProvider.products
    }
    
    fileprivate let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        let backgroundIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tableView.backgroundView = backgroundIndicator
        backgroundIndicator.startAnimating()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: fetch
    func fetchProducts() {
        indicatorView.startAnimating()
        productProvider.fetchProducts { newProds, error in
            self.indicatorView.stopAnimating()
            if let err = error as? ErrorDisplayable,
                let errorMessage = err.description {
                Utils.showAlert(from: self, message: errorMessage)
                let label = UILabel()
                label.text = errorMessage
                self.tableView.backgroundView = label
            }
            
            if let count = newProds?.count, count > 0 {
                if self.tableView.tableFooterView != self.indicatorView {
                    self.tableView.tableFooterView = self.indicatorView
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        cell.product = product

        //prefetch if possible
        if let lastIndexPath = tableView.indexPathsForVisibleRows?.last, ProductsContainer.shared.shouldPrefetch(at: lastIndexPath.row) {
                fetchProducts()
        }
        return cell
    }
}

extension ListViewController: ProductCellDelegate {
    func shouldSetImage(for indexPath: IndexPath) -> Bool {
        return tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false
    }
}

//MARK: Navigation to Detail
extension ListViewController: UITableViewDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let index = selectedIndex else { return }
        
        let prod = products[index]
        guard let pageViewController = segue.destination as? ProductPageViewController else {
            return
        }
        let detailViewController: DetailViewController? = Utils.createViewControllerFromStoryboard(identifier: DetailViewController.identifier)
        
        if let detailViewController = detailViewController {
            detailViewController.product = prod
            detailViewController.index = index
            
            pageViewController.setViewControllers([detailViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "DetailViewController", sender: self)
    }
}

