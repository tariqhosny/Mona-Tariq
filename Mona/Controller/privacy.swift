//
//  privacy.swift
//  Mona
//
//  Created by Tariq on 9/18/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class privacy: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var privacy: UILabel!
    
    var policies = [productsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if revealViewController() != nil {
            if MOLHLanguage.currentAppleLanguage() == "en"{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }else{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        privacyHandleRefresh()
    }
    
    @objc fileprivate func privacyHandleRefresh() {
        profileApi.privacyApi { (error: Error?, privacy: [productsModel]?) in
            if let privacies = privacy{
                self.policies = privacies
                self.privacy.text = self.policies[0].productDescription
            }
        }
    }

}
