//
//  rightSideMenu.swift
//  Mona
//
//  Created by Tariq on 9/22/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class rightSideMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Select Language", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "English", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("en")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: "עברית", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("he")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: "عربى", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("ar")
            MOLH.reset()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to log out?", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action: UIAlertAction) in
            let defUser = UserDefaults.standard
            defUser.removeObject(forKey: "user_token")
            helper.restartApp()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
