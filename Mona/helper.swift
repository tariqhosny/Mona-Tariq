//
//  helper.swift
//  Mona
//
//  Created by Tariq on 8/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class helper: NSObject {
    
    class func saveUserToken(token: String, password: String){
        let defUser = UserDefaults.standard
        defUser.setValue(password, forKey: "password")
        defUser.setValue(token, forKey: "user_token")
        defUser.synchronize()
        restartApp()
    }
    
    class func getUserToken() -> (token: String?, password: String?) {
        let defUser = UserDefaults.standard
        return (defUser.object(forKey: "user_token") as? String, defUser.object(forKey: "password") as? String)
    }
    
    class func restartApp(){
        guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        if getUserToken().token == nil{
            vc = sb.instantiateInitialViewController()!
        }else{
            vc = sb.instantiateViewController(withIdentifier: "home")
        }
        window.rootViewController = vc
    }
    
    var cart = Int()
    
    @objc func cartCount() -> Int{
        cartApi.listCartApi { (error: Error?, product: [productsModel]?, price, taxs, deleveryFees) in
            self.cart = product!.count
        }
        return cart
    }
    
}
