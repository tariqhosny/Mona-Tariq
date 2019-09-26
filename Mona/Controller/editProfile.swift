//
//  editProfile.swift
//  Mona
//
//  Created by Tariq on 9/2/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class editProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var oldPasswordTf: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chooseBuuton: UIButton!
    
    var picker = UIImagePickerController()
    var profileImage = ordersAndWishlist()
    var profile = [productsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.activityIndicator.isHidden = true
        
        picker.delegate=self
        
        profileHandleRefresh()
        addTitleImage()
        
    }
    
    @objc fileprivate func profileHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        profileApi.profileApi { (error: Error?, profile: [productsModel]?) in
            if let profileData = profile{
                self.profile = profileData
                self.nameTf.text = self.profile[0].customerName
                self.phoneTf.text = self.profile[0].customerPhone
                self.emailTf.text = self.profile[0].customerEmail
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func addTitleImage(){
        let navController = navigationController!
        
        let image = UIImage(named: "Mona")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @IBAction func editProfileBtn(_ sender: Any) {
        
        if newPasswordTf.text != ""{
            if helper.getUserToken().password == oldPasswordTf.text{
                profileApi.updateProfileApi(name: nameTf.text ?? "", email: emailTf.text ?? "", phone: phoneTf.text ?? "", password: newPasswordTf.text ?? "") { (error, message) in
                    let alert = UIAlertController(title: NSLocalizedString("Profile Updated", comment: ""), message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
                        helper.saveUserToken(token: helper.getUserToken().token ?? "", password: self.newPasswordTf.text ?? "")
                        print("profile updated")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                let alert = UIAlertController(title: NSLocalizedString("Old Password Not Match", comment: ""), message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            profileApi.updateProfileApi(name: nameTf.text ?? "", email: emailTf.text ?? "", phone: phoneTf.text ?? "", password: "") { (error, message) in
                let alert = UIAlertController(title: NSLocalizedString("Profile Updated", comment: ""), message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("profile updated")
            }
        }
    }
    
    @IBAction func chooseBtn() {
        let alert = UIAlertController(title: NSLocalizedString("Uploade Image", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("From Gallary", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("From Camera", comment: ""), style: .destructive, handler: { (action: UIAlertAction) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openGallary()
    {
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
        }else if let chosenImage = info[.originalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = chosenImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
