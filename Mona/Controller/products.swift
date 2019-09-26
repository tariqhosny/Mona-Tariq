//
//  products.swift
//  Mona
//
//  Created by Tariq on 9/3/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class products: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    var products = [productsModel]()
    var cart = [productsModel]()
    var catId = String()
    var brandId = String()
    var productDescription = String()
    var productShortDescription = String()
    var productPrice = String()
    var productSalePrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var brand = String()
    var imageGuide = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        productsCollectionView.refreshControl = refreshControl
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        cartCounter()
        addTitleImage()
        productsHandleRefresh()
        
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartCounter()
        addTitleImage()
        productsHandleRefresh()
    }
    
    @objc func refresh(sender:AnyObject) {
        productsHandleRefresh()
        refreshControl.endRefreshing()
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
    
    @objc fileprivate func productsHandleRefresh() {
        productApi.productApi(catID: catId, brandID: brandId) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.products = products
                self.productsCollectionView.reloadData()
            }
            self.addBadge()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? productDetails{
            destenation.productsDescription = self.productDescription
            destenation.productPrice = self.productPrice
            destenation.productSalePrice = self.productSalePrice
            destenation.productTitle = self.productTitle
            destenation.productID = self.productID
            destenation.isFavorite = self.isFavorite
            destenation.brandName = self.brand
            destenation.imageGuide = self.imageGuide
        }
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

extension products: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productsCell", for: indexPath) as! productsCell
        let productData = products[indexPath.item]
        cell.configureCell(product: productData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productDescription = products[indexPath.item].shortDescription
        self.productShortDescription = products[indexPath.item].productDescription
        self.productPrice = products[indexPath.item].price
        self.productSalePrice = products[indexPath.item].salePrice
        self.productTitle = products[indexPath.item].title
        self.productID = products[indexPath.item].id
        self.isFavorite = products[indexPath.item].isFavorite
        self.brand = products[indexPath.item].brand
        self.imageGuide = products[indexPath.item].imageGuide
        performSegue(withIdentifier: "details", sender: products[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        var width = (screenWidth-20)/2
        width = width < 130 ? 160 : width
        return CGSize.init(width: width, height: 207)
    }
}
