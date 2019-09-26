//
//  cart.swift
//  Mona
//
//  Created by Tariq on 8/27/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class cart: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var supTotalLb: UILabel!
    @IBOutlet weak var taxesLb: UILabel!
    @IBOutlet weak var deliveryFeesLb: UILabel!
    @IBOutlet weak var totalPriceLb: UILabel!
    @IBOutlet weak var priceData: UIStackView!
    
    var refreshControl = UIRefreshControl()
    var products = [productsModel]()
    var cartID = Int()
    var price = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.activityIndicator.isHidden = true
        
        if self.products.count == 0 {
            self.priceData.isHidden = true
        }else{
            self.priceData.isHidden = false
        }
        
        tableView.delegate = self
        tableView.dataSource = self

        cartHandleRefresh()
        addTitleImage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartHandleRefresh()
        addTitleImage()
    }
    
    @objc func refresh(sender:AnyObject) {
        cartHandleRefresh()
        refreshControl.endRefreshing()
    }
    
    @objc func cartHandleRefresh() {
        cartApi.listCartApi { (error: Error?, product: [productsModel]?, price, taxs, deleveryFees) in
            if let products = product {
                self.products = products
                print(self.products)
                self.price = price ?? 0
                self.totalPriceLb.text = " $\(price ?? 0)"
                self.taxesLb.text = " $\(taxs ?? 0)"
                self.deliveryFeesLb.text = " $\(deleveryFees ?? "0")"
                self.tableView.reloadData()
            }
            if self.products.count == 0 {
                self.priceData.isHidden = true
            }else{
                self.priceData.isHidden = false
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? createOrder{
            destenation.totalPrice = self.price
        }
    }
    
}
extension cart : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var subTotalPrice = 0
        for item in products {
            subTotalPrice += item.totalUnitPrice
        }
        supTotalLb.text = " $\(subTotalPrice)"
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! cartCell
        let productData = products[indexPath.row]
        cell.plus = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.plusCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("increased")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        cell.min = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.minCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("decreased")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
        }
        cell.delete = {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.deleteCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("deleted")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            if self.products.count == 1 {
                self.products.removeAll()
                self.supTotalLb.text = " $0"
                self.totalPriceLb.text = " $0"
                self.taxesLb.text = " $0"
                self.deliveryFeesLb.text = " $0"
                self.tableView.reloadData()
            }
        }
        cell.configureCell(product: productData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let indexpath = IndexPath(item: 0, section: 0)
        _ = self.tableView.cellForRow(at: indexpath) as! cartCell
        if (editingStyle == .delete) {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.cartID = self.products[indexPath.row].cartID
            cartApi.deleteCartApi(cartID: self.cartID, completion: { (error: Error?, success: Bool?) in
                if success == true{
                    print("deleted")
                    self.cartHandleRefresh()
                }else{
                    print("failed")
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            })
            if self.products.count == 1 {
                self.products.removeAll()
                self.supTotalLb.text = " $0"
                self.totalPriceLb.text = " $0"
                self.taxesLb.text = " $0"
                self.deliveryFeesLb.text = " $0"
                self.tableView.reloadData()
            }
            
        }
    }
    
}
