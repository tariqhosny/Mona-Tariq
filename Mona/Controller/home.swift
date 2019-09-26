//
//  home.swift
//  Mona
//
//  Created by Tariq on 8/25/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class home: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var brandTF: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let catPickerView = UIPickerView()
    let brandPickerView = UIPickerView()
    
    var refreshControl = UIRefreshControl()
    var slider = [productsModel]()
    var allProducts = [productsModel]()
    var categoryPicker = [productsModel]()
    var brandPicker = [productsModel]()
    var cart = [productsModel]()
    var productsDescription = String()
    var productPrice = String()
    var productSalePrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var currentIndex = 0
    var catID = String()
    var brandID = String()
    var timer : Timer?
    var brand = String()
    var imageGuide = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        productsCollectionView.refreshControl = refreshControl
        
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
        //hideKeyboardWhenTappedAround()
        
        catPickerView.delegate = self
        catPickerView.dataSource = self
        brandPickerView.delegate = self
        brandPickerView.dataSource = self
        
        categoryTF.inputView = catPickerView
        brandTF.inputView = brandPickerView
        
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        categoryTF.delegate = self
        brandTF.delegate = self
        
        addTFImage(textField: categoryTF)
        addTFImage(textField: brandTF)
        
        
        addTitleImage()
        startTimer()
        cartCounter()
        sliderHandleRefresh()
        productHandleRefresh()
        brandsHandleRefresh()
        categoriesHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartCounter()
        allProductHandleRefresh()
        categoryTF.text = ""
        brandTF.text = ""
    }
    
    @objc func refresh(sender:AnyObject) {
        allProductHandleRefresh()
        categoryTF.text = ""
        brandTF.text = ""
        refreshControl.endRefreshing()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == categoryTF{
            catID = ""
            allProductHandleRefresh()
            productHandleRefresh()
        }else{
            brandID = ""
            allProductHandleRefresh()
            productHandleRefresh()
        }
        
        return true
    }
    
    @objc fileprivate func categoriesHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.catigoriesApi(url: URLs.categories) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.categoryPicker = products
                self.catPickerView.reloadAllComponents()
            }
            self.addBadge()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @objc fileprivate func brandsHandleRefresh() {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
        productApi.catigoriesApi(url: URLs.brands) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.brandPicker = products
                self.brandPickerView.reloadAllComponents()
            }
            self.addBadge()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @objc fileprivate func sliderHandleRefresh() {
        homeApi.sliderPhotos { (error: Error?, photos:[productsModel]?) in
            if let photos = photos {
                self.slider = photos
                self.pageControl.numberOfPages = self.slider.count
                self.pageControl.currentPage = 0
                self.sliderCollectionView.reloadData()
            }
            self.addBadge()
        }
    }
    
    @objc fileprivate func productHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.allProducts.removeAll()
        productApi.productApi(catID: catID, brandID: brandID) { (error: Error?, products: [productsModel]?) in
            if let product = products {
                self.allProducts = product
                self.productsCollectionView.reloadData()
            }
            if self.categoryTF.text == "" && self.brandTF.text == "" {
                self.allProductHandleRefresh()
            }
            self.addBadge()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
    }
    
    @objc fileprivate func allProductHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        productApi.allProductsApi{ (error: Error?, products: [productsModel]?) in
            if let product = products {
                self.allProducts = product
                self.productsCollectionView.reloadData()
            }
            self.addBadge()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
    }
    
    func startTimer(){
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        
        if currentIndex < slider.count {
            let index = IndexPath.init(item: currentIndex, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentIndex
            currentIndex += 1
        } else {
            currentIndex = 0
            let index = IndexPath.init(item: currentIndex, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = currentIndex
            currentIndex = 1
        }
        
    }
    
    @objc func timerAction(){
        let desiredScrollPosition = (currentIndex < slider.count - 1) ? currentIndex + 1 : 0
        sliderCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destenation = segue.destination as? productDetails{
            destenation.productsDescription = self.productsDescription
            destenation.productPrice = self.productPrice
            destenation.productTitle = self.productTitle
            destenation.productID = self.productID
            destenation.isFavorite = self.isFavorite
            destenation.brandName = self.brand
            destenation.imageGuide = self.imageGuide
        }
    }
    
    func addTFImage(textField: UITextField){
        textField.leftViewMode = UITextField.ViewMode.unlessEditing
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "ChevronDown")
        imageView.image = image
        textField.leftView = imageView
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
extension home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDataSource, UIPickerViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.sliderCollectionView{
            return slider.count
        }else {
            return allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.productsCollectionView{
            if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeProductCell", for: indexPath) as? homeProductCell{
                if allProducts.count != 0{
                    let productData = allProducts[indexPath.item]
                    productCell.configureCell(product: productData)
                }else{
                    productHandleRefresh()
                }
                return productCell
            }else{
                return homeProductCell()
            }
        }else{
            let topCell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeSliderCell", for: indexPath) as! homeSliderCell
            
            let sliderImg = slider[indexPath.item]
            topCell.configureCell(slider: sliderImg)
            
            return topCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productsCollectionView{
            self.productsDescription = allProducts[indexPath.item].productDescription
            self.productPrice = allProducts[indexPath.item].price
            self.productSalePrice = allProducts[indexPath.item].salePrice
            self.productTitle = allProducts[indexPath.item].title
            self.productID = allProducts[indexPath.item].id
            self.isFavorite = allProducts[indexPath.item].isFavorite
            self.brand = allProducts[indexPath.item].brand
            self.imageGuide = allProducts[indexPath.item].imageGuide
            performSegue(withIdentifier: "details", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1{
            let screenWidth = collectionView.frame.width
            var width = (screenWidth-10)/2
            width = width < 130 ? 160 : width
            return CGSize.init(width: width, height: 207)
        }else {
            return CGSize.init(width: collectionView.frame.size.width, height: 190)
        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.tag == 0{
//            currentIndex = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
//            pageControl.currentPage = currentIndex
//        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == catPickerView{
            return categoryPicker.count
        }else{
            return brandPicker.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == catPickerView{
            return categoryPicker[row].title
        }else{
            return brandPicker[row].title
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        allProducts.removeAll()
        if pickerView == catPickerView{
            allProducts.removeAll()
            catID = "\(categoryPicker[row].id)"
            productsCollectionView.reloadData()
            productHandleRefresh()
            categoryTF.text = categoryPicker[row].title
        }else{
            allProducts.removeAll()
            brandID = "\(brandPicker[row].id)"
            productsCollectionView.reloadData()
            productHandleRefresh()
            brandTF.text = brandPicker[row].title
        }
        if categoryTF.text == "" && brandTF.text == ""{
            allProducts.removeAll()
            allProductHandleRefresh()
        }
    }
    
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
}
