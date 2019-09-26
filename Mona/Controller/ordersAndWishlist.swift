//
//  ordersAndWishlist.swift
//  Mona
//
//  Created by Tariq on 8/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class ordersAndWishlist: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var whishlistCollectionView: UICollectionView!
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var products = [productsModel]()
    var orders = [productsModel]()
    var profile = [productsModel]()
    var productsDescription = String()
    var productPrice = String()
    var productSalePrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = 1
    var brand = String()
    var imageGuide = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        whishlistCollectionView.delegate = self
        whishlistCollectionView.dataSource = self
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        wishlistHandleRefresh()
        OrderListHandleRefresh()
        addTitleImage()
    }
    override func viewDidAppear(_ animated: Bool) {
        wishlistHandleRefresh()
        OrderListHandleRefresh()
        addTitleImage()
    }
    
    @objc fileprivate func wishlistHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        favoriteApi.favoriteListApi { (error: Error?, product: [productsModel]?) in
            self.products = product ?? []
            self.whishlistCollectionView.reloadData()
            self.segmentedControl.setTitle("\(self.products.count) \(NSLocalizedString("WISHLISTS", comment: ""))", forSegmentAt: 1)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? productDetails{
            destenation.productsDescription = self.productsDescription
            destenation.productPrice = self.productPrice
            destenation.productSalePrice = self.productSalePrice
            destenation.productTitle = self.productTitle
            destenation.productID = self.productID
            destenation.isFavorite = self.isFavorite
            destenation.brandName = self.brand
            destenation.imageGuide = self.imageGuide
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
    
    @objc fileprivate func OrderListHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        orderApi.orderListApi { (error: Error?, orderList: [productsModel]?) in
            if let products = orderList {
                self.orders = products
                self.orderTableView.reloadData()
            }
            self.segmentedControl.setTitle("\(self.orders.count) \(NSLocalizedString("ORDERS", comment: ""))", forSegmentAt: 0)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func segmentedPressed(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            OrderListHandleRefresh()
            self.whishlistCollectionView.isHidden = true
            self.orderTableView.isHidden = false
        case 1:
            wishlistHandleRefresh()
            self.orderTableView.isHidden = true
            self.whishlistCollectionView.isHidden = false
        default:
            print("AnyThing")
        }
    }
    
}
extension ordersAndWishlist: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! orderCell
        let productData = orders[indexPath.row]
        cell.configureCell(orderList: productData)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.orderPrice = products[indexPath.item].orderPrice
//        self.orderID = products[indexPath.item].orderID
//        self.deleveryFees = products[indexPath.item].deleveryFees
//        self.taxs = products[indexPath.item].taxs
//        self.address = "\(products[indexPath.item].country), \(products[indexPath.item].city), \(products[indexPath.item].address), \(products[indexPath.item].street)"
//
//        if Int(products[indexPath.item].orderState) == 0{
//            self.orderState = NSLocalizedString("Order in Progress", comment: "")
//        }
//        if Int(products[indexPath.item].orderState) == 1{
//            self.orderState = NSLocalizedString("Order Delivered", comment: "")
//        }
//        if Int(products[indexPath.item].orderState) == 2{
//            self.orderState = NSLocalizedString("Order Canceled", comment: "")
//        }
//        
//        performSegue(withIdentifier: "segue", sender: nil)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlistCell", for: indexPath) as! wishlistCell
        let productData = products[indexPath.item]
        cell.configureCell(product: productData)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.productsDescription = products[indexPath.item].productDescription
        self.productPrice = products[indexPath.item].price
        self.productSalePrice = products[indexPath.item].salePrice
        self.productTitle = products[indexPath.item].productName1
        self.productID = Int(products[indexPath.item].productID1) ?? 0
        self.brand = products[indexPath.item].brand
        self.imageGuide = products[indexPath.item].imageGuide
        performSegue(withIdentifier: "details", sender: products[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width

        var width = (screenWidth-20)/2

        width = width < 130 ? 170 : width

        return CGSize.init(width: width, height: 195)
    }
}
