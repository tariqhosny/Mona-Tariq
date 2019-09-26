//
//  detailsImagesCell.swift
//  Mona
//
//  Created by Tariq on 8/26/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class detailsImagesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImage: UIImageView!
    
    func configureCell(product: productsModel) {
        let urlWithoutEncoding = ("\(URLs.file_root)\(product.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        productImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            productImage.kf.setImage(with: url)
        }
    }
    
}
