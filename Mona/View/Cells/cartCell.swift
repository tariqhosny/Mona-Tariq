//
//  cartCell.swift
//  Mona
//
//  Created by Tariq on 8/27/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class cartCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productSize: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    var plus: (()->())?
    var min: (()->())?
    var delete: (()->())?
    
    func configureCell(product: productsModel) {
        productSize.text = product.size
        productBrand.text = product.brand
        self.colorView.backgroundColor = hexStringToUIColor(hex: product.color)
        productName.text = product.productName
        productPrice.text = "\(product.totalUnitPrice)"
        counter.text = product.counter
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF,
            blue: CGFloat(rgbValue & 0x0000FF) / 0xFF,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func plusBtn(_ sender: UIButton) {
        plus?()
    }
    
    @IBAction func minBtn(_ sender: Any) {
        min?()
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        delete?()
    }
    
    
}
