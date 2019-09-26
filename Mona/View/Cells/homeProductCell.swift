//
//  homeSliderCell.swift
//  Mona
//
//  Created by Tariq on 8/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class homeProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    func configureCell(product: productsModel) {
        productName.text = product.title
        productBrand.text = product.brand
        if product.salePrice == ""{
            productPrice.text = product.price
        }else{
            productPrice.text = product.salePrice
        }
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
    
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.borderWidth = 0.2
        self.contentView.layer.borderColor = UIColor.gray.cgColor
    }
}
