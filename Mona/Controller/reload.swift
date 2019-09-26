//
//  reload.swift
//  Mona
//
//  Created by Tariq on 9/4/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class reload: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.startAnimating()
        
        checkConnection()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        checkConnection()
    }
    
    func checkConnection(){
        if Reachability.isConnectedToNetwork() == true{
            helper.restartApp()
        }else{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .destructive, handler: { (action: UIAlertAction) in
//                    let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "reload")
//                    self.window?.rootViewController = tab
                self.viewDidLoad()
                self.viewWillAppear(true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
