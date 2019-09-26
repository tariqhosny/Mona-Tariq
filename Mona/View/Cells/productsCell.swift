//
//  productsCell.swift
//  Mona
//
//  Created by Tariq on 9/3/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class productsCell: UICollectionViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    
    func configureCell(product: productsModel) {
        productName.text = product.title
        if product.salePrice == ""{
            productPrice.text = product.price
        }else{
            productPrice.text = product.salePrice
        }
        productBrand.text = product.brand
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImg.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImg.kf.setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.borderWidth = 0.1
        self.contentView.layer.borderColor = UIColor.gray.cgColor
    }
    
}
