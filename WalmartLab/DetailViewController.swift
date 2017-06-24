//
//  DetailViewController.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    static let identifier = "DetailViewController"
    
    var product: Product?
    var index: Int?

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var longDescription: UILabel!
    @IBOutlet weak var ratingAndCount: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var inStock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        guard let product = product else { return }
        name.text = product.name
        price.text = product.price
        longDescription.attributedText = product.longDescription.attributedHTMLString()
        let ratingStr = String(format: "%.1f", product.reviewRating)
        ratingAndCount.text = "Rating: \(ratingStr) Reviews: \(product.reviewCount)"
        ratingView.rating = product.reviewRating
        inStock.text = product.inStock ? "In Stock" : "Out of Stock"
        inStock.textColor = product.inStock ? UIColor.green : UIColor.red
        
        if let imageUrl = product.imageUrl {
            ProductsContainer.shared.fetchImage(for: imageUrl) { image in
                self.productImageView.image = image
            }
        }
    }
    
}
