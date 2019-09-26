//
//  colorCell.swift
//  Mona
//
//  Created by Tariq on 8/26/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class colorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    func configureCell(product: productsModel) {
        self.colorView.backgroundColor = hexStringToUIColor(hex: product.color)
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    override var isSelected: Bool {
        didSet{
            layer.cornerRadius = isSelected ? 5.0 : 0.0
            layer.borderWidth =  isSelected ? 1.0 : 0.0
            layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
}
