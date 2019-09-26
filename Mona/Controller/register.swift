//
//  register.swift
//  Mona
//
//  Created by Tariq on 8/22/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class register: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.delegate = self

        self.activityIndicator.isHidden = true
        hideKeyboardWhenTappedAround()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        guard let name = nameTF.text, let phone = phoneTF.text, let email = emailTF.text, let password = passwordTF.text, let address = addressTF.text else {return}
        if (email.isEmpty == true || password.isEmpty == true || name.isEmpty == true || phone.isEmpty == true){
            self.displayErrors(errorText: NSLocalizedString("Empty Fields", comment: ""))
        }else if password.count < 6 {
            self.displayErrors(errorText: NSLocalizedString("The password must be at least 6 characters", comment: ""))
        }else {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            authApi.register(name: name, phone: phone, email: email, password: password, address: address) { (error: Error?, success: Bool, validation: String) in
                if success {
                    print("sign up successfully")
                }else{
                    self.displayErrors(errorText: validation)
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorText, preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension register {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

    


