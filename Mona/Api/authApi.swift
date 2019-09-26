//
//  authApi.swift
//  Mona
//
//  Created by Tariq on 8/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class authApi: NSObject {
    
    class func login(email: String, password: String, completion: @escaping (_ error: Error?, _ success: Bool)-> Void){
        let url = URLs.login
        
        let parametars = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch response.result{
                case .failure(let error):
                    completion(error, false)
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    let status = json["status"].bool
                    if status == true{
                        if let user_token = json["data"]["user_token "].string {
                            completion(nil, true)
                            helper.saveUserToken(token: user_token, password: password)
                        }
                    }else{
                        completion(nil, false)
                    }
                }
        }
    }
    
    class func register(name: String, phone: String, email: String, password: String, address: String, completion: @escaping (_ error: Error?, _ success: Bool, _ validationMessage: String)-> Void){
        let url = URLs.register
        
        let parametars = [
            "name": name,
            "phone": phone,
            "email": email,
            "password": password
        ]
        
        Alamofire.request(url, method: .post, parameters: parametars, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch response.result{
                case .failure(let error):
                    completion(error, false, "")
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    let status = json["status"].bool
                    if status == true{
                        if let user_token = json["data"]["user_token "].string{
                            completion(nil, true, "")
                            helper.saveUserToken(token: user_token, password: password)
                        }
                    }else{
                        if let validationMail = json["error"]["email"][0].string{
                            completion(nil, false, validationMail)
                        }
                        else if let validationName = json["error"]["name"][0].string{
                            completion(nil, false, validationName)
                        }
                        
                    }
                }
        }
    }
    
}
