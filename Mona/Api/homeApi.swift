//
//  homeApi.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/24/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class homeApi: NSObject {
    
    
    class func sliderPhotos (completion: @escaping(_ error: Error?, _ photos: [productsModel]?)-> Void){
        let parametars = [
            "lang": NSLocalizedString("en", comment: "")
        ]
        let header = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(URLs.slider, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: header).responseJSON { response in
            
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
