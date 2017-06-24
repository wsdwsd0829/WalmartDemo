//
//  Utils.swift
//  WalmartLab
//
//  Created by Sida Wang on 6/17/17.
//  Copyright © 2017 Sida Wang. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    open static func createViewControllerFromStoryboard<T>(identifier: String, storyboardName name: String = "Main") -> T? {
        let detailViewController = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier) as? T
        return detailViewController
    }
}

extension String {
    ///Helper: convert string to HTML version's AttributtedString
    func attributedHTMLString() -> NSAttributedString {
        let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        if let data = self.data(using: String.Encoding.utf8) {
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString ?? NSAttributedString(string: "")
        }
        return NSAttributedString(string: "")
    }
}

extension Utils {
    static func showAlert(from viewController: UIViewController, message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
    }
}
