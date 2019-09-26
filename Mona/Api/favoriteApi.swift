//
//  favoriteApi.swift
//  Mona
//
//  Created by Tariq on 8/27/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class favoriteApi: NSObject {
    
    class func setFavoriteApi (product_id: Int, completion: @escaping(_ error: Error?, _ status: Bool?, _ error: String?)-> Void){
        let parametars = [
            "product_id": product_id,
            "lang": NSLocalizedString("en", comment: "")
            ] as [String : Any]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.favorite, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil, nil)
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                if let status = json["status"].bool {
                    if status{
                        completion(nil, status, nil)
                        print("successful")
                    }else{
                        if let error = json["error"].string {
                            completion(nil, status, error)
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    class func favoriteListApi (completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
        ]
        let header = [
            "Accept": "application/json",
            "Authorization": "Bearer \(helper.getUserToken().token ?? "")"
        ]
        Alamofire.request(URLs.favoriteList, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            
            switch response.result
            {
            case .failure(let error):
                print(error)
                completion(error, nil)
                
            case .success(let value):
                let json = JSON(value)
                
                guard let data = json["data"].array else {
                    completion(nil, nil)
                    return
                }
                
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
