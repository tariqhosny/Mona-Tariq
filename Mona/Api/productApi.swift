//
//  productApi.swift
//  Mona
//
//  Created by Tariq on 8/26/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class productApi: NSObject {
    
    class func catigoriesApi (url:String,completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "lang": "en"
        ]
        Alamofire.request(url, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productApi (catID: String, brandID: String, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "category_id": catID,
            "brand_id": brandID,
            "lang": NSLocalizedString("en", comment: "")
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.products, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func allProductsApi (completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
            ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.allProducts, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
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
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productImagesApi (id: Int, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "product_id": id
        ]
        Alamofire.request(URLs.productImages, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productColorsApi (id: Int, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "product_id": id
        ]
        Alamofire.request(URLs.productColor, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
    
    class func productSizesApi (id: Int, color: String, completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "product_id": id,
            "hash_color": color
            ] as [String : Any]
        Alamofire.request(URLs.sizes, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil).responseJSON { response in
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
                //print(data)
                var photos = [productsModel]()
                data.forEach({
                    if let dict = $0.dictionary, let photo = productsModel(dict: dict) {
                        photos.append(photo)
                    }
                })
                completion(nil, photos)
            }
        }
    }
}
