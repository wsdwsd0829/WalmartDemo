//
//  RatingView.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/22/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import UIKit

class RatingView: UIView {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var imageViews: [UIImageView]!
    var rating: Double! = 0 {
        didSet {
            if rating > 5 {
                rating = Double(Int(rating) % 5) //fall back for safty
            }
            if rating < 0 {
                rating = 0
            }
            let fullCount = Int(rating)
            var hasHalf = false
            let diff = rating - Double(fullCount)
            if diff > 0.0 {
                hasHalf = true
            }
            for i in 0..<fullCount {
                imageViews[i].image = UIImage(named: "YellowFull")
            }
            if hasHalf {
                imageViews[fullCount].image = UIImage(named: "YellowHalf")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.view = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)?.last as! UIView
        self.addSubview(view)
        view.frame = self.frame
    }
}
