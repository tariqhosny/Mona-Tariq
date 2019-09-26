//
//  login.swift
//  Mona
//
//  Created by Tariq on 8/22/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class login: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTF.text, let password = passwordTF.text else {return}
        print(email + password)
        if (email.isEmpty == true || password.isEmpty == true){
            self.displayErrors(errorText: NSLocalizedString("Empty Fields", comment: ""))
        }else {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            authApi.login(email: email, password: password) { (error: Error?, success: Bool) in
                if success == true {
                    print("login successfully")
                }else{
                    self.displayErrors(errorText: NSLocalizedString("Email or Password incorrect", comment: ""))
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: NSLocalizedString("Message", comment: ""), message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension login {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
