//
//  orderApi.swift
//  Mona
//
//  Created by Tariq on 8/28/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class orderApi: NSObject {
    
    class func createOrderApi (totalPrice: Int, phone: String, address: String, notes: String, city: String, country: String, street: String, latidude: Float, langitude: Float, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "order_total_price": totalPrice,
            "customer_address": address,
            "customer_phone": phone,
            "langtude": latidude,
            "lattude": langitude,
            "payment_method": 1,
            "payment_status": 1,
            "customer_comments_extra": notes,
            "customer_city": city,
            "customer_country": country,
            "customer_street": street,
            "customer_postal_code": 0
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.createOrder, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(nil, true)
            }
        }
    }
    
    class func orderListApi (completion: @escaping(_ error: Error?, _ data: [productsModel]?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.orderList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                var orderList = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productsModel(dict: dict) {
                        orderList.append(product)
                    }
                })
                completion(nil, orderList)
            }
        }
    }
    
    class func orderDetailsApi (orderID:Int, completion: @escaping(_ error: Error?, _ data: [productsModel]?)-> Void){
        let parametars = [
            "order_id": orderID
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.orderDetails, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                var orderDetails = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let product = productsModel(dict: dict) {
                        orderDetails.append(product)
                    }
                })
                completion(nil, orderDetails)
            }
        }
    }
}
