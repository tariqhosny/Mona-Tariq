//
//  cartApi.swift
//  Mona
//
//  Created by Tariq on 8/27/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class cartApi: NSObject {
    var cartCount = Int()
    
    class func addCartApi (id: Int,color_id: Int, size: String, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "product_id": id,
            "color_id": color_id,
            "product_quantity": 1,
            "size": size
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.addCart, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
    
    
    class func listCartApi (completion: @escaping(_ error: Error?, _ data: [productsModel]?, _ totalPrice: Int?, _ taxs: Int?, _ deleveryFees: String?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.cartList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil,nil, nil,nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].dictionary else {
                    completion(nil, nil, nil, nil,nil)
                    return
                }
                guard let totalPrice = data["price"]?.int else{
                    completion(nil, nil, nil, nil,nil)
                    return
                }
                guard let totalTax = data["total_tax"]?.int else{
                    completion(nil, nil, nil, nil,nil)
                    return
                }
                guard let deleveryFees = data["total_delevery_fees"]?.string else{
                    completion(nil, nil, nil, nil,nil)
                    return
                }
                guard let list = data["list"]?.array else {
                    completion(nil, nil, nil, nil,nil)
                    return
                }
                var cartData = [productsModel]()
                list.forEach({
                    if let dict = $0.dictionary, let product = productsModel(dict: dict) {
                        cartData.append(product)
                    }
                })
                completion(nil, cartData, totalPrice, totalTax, deleveryFees)
            }
        }
    }
    
    class func plusCartApi (cartID: Int, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "cart_id": cartID,
            "product_quantity": 1
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.plusCart, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
    
    class func minCartApi (cartID: Int, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "cart_id": cartID,
            "product_quantity": 1
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.minCart, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
    
    class func deleteCartApi (cartID: Int, completion: @escaping(_ error: Error?, _ success: Bool?)-> Void){
        let parametars = [
            "cart_id": cartID,
            "product_quantity": 1
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.deleteCart, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
    
    class func cartCountApi (completion: @escaping(_ error: Error?, _ data: [productsModel]?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.cartList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                guard let data = json["data"].dictionary else {
                    completion(nil, nil)
                    return
                }
                guard let list = data["list"]?.array else {
                    completion(nil, nil)
                    return
                }
                var cartData = [productsModel]()
                list.forEach({
                    if let dict = $0.dictionary, let product = productsModel(dict: dict) {
                        cartData.append(product)
                    }
                })
                completion(nil, cartData)
            }
        }
    }
    
}
