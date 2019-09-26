//
//  ViewController.swift
//  Mona
//
//  Created by Tariq on 8/22/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class start: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        
    }


}
