//
//  detailsSizes.swift
//  Mona
//
//  Created by Tariq on 8/26/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class detailsSizes: UICollectionViewCell {

    @IBOutlet weak var sizeLb: UILabel!
    
    func configureCell(product: productsModel) {
        sizeLb.text = product.size
    }
    
    override func awakeFromNib() {
//        self.layer.cornerRadius = 15
//        self.contentView.layer.borderColor = UIColor.gray.cgColor
//        self.clipsToBounds = true
//        self.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet{
            layer.cornerRadius = isSelected ? 5.0 : 0.0
            layer.borderWidth =  isSelected ? 1.0 : 0.0
            layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

    
}
