//
//  orderCell.swift
//  Mona
//
//  Created by Tariq on 8/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class orderCell: UITableViewCell {
    
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var viewContent: UIView!
    
    func configureCell(orderList: productsModel) {
        orderId.text = NSLocalizedString("order:", comment: "") + " \(orderList.orderID)"
        orderDate.text = NSLocalizedString("Date:", comment: "") + " \(orderList.orderDate)"
        orderPrice.text = " $\(orderList.orderPrice)"
        
        if Int(orderList.orderState) == 0{
            orderState.text = NSLocalizedString("Order in Progress", comment: "")
        }
        if Int(orderList.orderState) == 1{
            orderState.text = NSLocalizedString("Order Delivered", comment: "")
        }
        if Int(orderList.orderState) == 2{
            orderState.text = NSLocalizedString("Order Canceled", comment: "")
        }
    }
    
    override func awakeFromNib() {
        viewContent.layer.cornerRadius = 10.0
        viewContent.layer.masksToBounds = true
        viewContent.layer.borderWidth = 0.2
        viewContent.layer.borderColor = UIColor.gray.cgColor
    }

}
