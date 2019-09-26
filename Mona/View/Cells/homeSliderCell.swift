//
//  homeProductCell.swift
//  Mona
//
//  Created by Tariq on 8/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Kingfisher

class homeSliderCell: UICollectionViewCell {
    
    @IBOutlet weak var sliderImage: UIImageView!
    
    func configureCell(slider: productsModel) {
        let urlWithoutEncoding = ("\(URLs.file_root)\(slider.photo)")
        let encodedLink = urlWithoutEncoding.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let encodedURL = NSURL(string: encodedLink!)! as URL
        sliderImage.kf.indicatorType = .activity
        if let url = URL(string: "\(encodedURL)") {
            sliderImage.kf.setImage(with: url)
        }
        
    }
}
