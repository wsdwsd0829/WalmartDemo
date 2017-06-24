//
//  ProductCell.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    func shouldSetImage(for indexPath: IndexPath) -> Bool
}

class ProductCell: UITableViewCell {
    static let identifier = "ProductCell"
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var ratingAndCount: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var inStock: UILabel!
    @IBOutlet weak var price: UILabel!
    var delegate: ProductCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    var indexPath: IndexPath?
    var product: Product? = nil {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard let product = product else { return }
        name.text = product.name
        shortDescription.attributedText = product.shortDescription.attributedHTMLString()
        let ratingStr = String(format: "%.1f", product.reviewRating)
        ratingAndCount.text = "Rating: \(ratingStr) Reviews: \(product.reviewCount)"
        ratingView.rating = product.reviewRating
        inStock.text = product.inStock ? "In stock" : "Out of Stock"
        inStock.textColor = product.inStock ? UIColor.green : UIColor.red
        price.text = product.price
        
        if let imageUrl = product.imageUrl {
            ProductsContainer.shared.fetchImage(for: imageUrl, handler: { image in
                if let indexPath = self.indexPath,
                    let shouldSet = self.delegate?.shouldSetImage(for: indexPath),
                    shouldSet == true {
                    self.productImageView?.image = image
                    self.productImageView?.contentMode = .scaleAspectFill
                }
            })
        }
    }
}
