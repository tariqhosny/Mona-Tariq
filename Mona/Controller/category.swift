//
//  category.swift
//  Mona
//
//  Created by Tariq on 9/3/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class category: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var refreshControl = UIRefreshControl()
    var products = [productsModel]()
    var cart = [productsModel]()
    
    var id = Int()
    var catId = String()
    var brandId = ""
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        categoryCollectionView.refreshControl = refreshControl
        
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
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.activityIndicator.isHidden = true
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        addTitleImage()
        cartCounter()
        categoriesHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartCounter()
        addTitleImage()
        categoriesHandleRefresh()
    }
    
    @objc func refresh(sender:AnyObject) {
        categoriesHandleRefresh()
        refreshControl.endRefreshing()
    }
    
    
    @objc fileprivate func categoriesHandleRefresh() {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
        productApi.catigoriesApi(url: URLs.categories) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.products = products
                print(self.products)
                self.categoryCollectionView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.addBadge()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? products{
            destenation.catId = self.catId
            destenation.brandId = self.brandId
        }
    }
    
    func addTitleImage(){
        let navController = navigationController!
        
        let image = UIImage(named: "Mona")
        let imageView = UIImageView(image: image)
        
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        
        let bannerX = (bannerWidth / 2 - (image?.size.width)! / 2)
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    
    @objc fileprivate func cartCounter(){
        cartApi.cartCountApi { (error: Error?, cartData: [productsModel]?) in
            if let cartCounter = cartData{
                self.cart = cartCounter
                print("caaarrrt: \(self.cart.count)")
            }
        }
    }
    
    func addBadge() {
        let bagButton = BadgeButton()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.white
        bagButton.setImage(UIImage(named: "shopping-cart"), for: .normal)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        bagButton.badge = "\(cart.count)"
        bagButton.addTarget(self, action: #selector(self.cartTaped), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bagButton)
    }
    
    @objc func cartTaped(){
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
    @IBAction func cartBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
}
extension category: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCell
        let product = products[indexPath.item]
        cell.configureCell(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.id = products[indexPath.item].id
        self.catId = "\(id)"
        performSegue(withIdentifier: "products", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenWidth = collectionView.frame.width
            var width = (screenWidth-10)/2
            width = width < 130 ? 160 : width
            return CGSize.init(width: width, height: 180)
    }
}
