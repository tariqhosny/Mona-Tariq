//
//  productDetails.swift
//  Mona
//
//  Created by Tariq on 8/26/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class productDetails: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    @IBOutlet weak var wishlistBtn: UIButton!
    
    var productImages = [productsModel]()
    var productColors = [productsModel]()
    var cart = [productsModel]()
    var sizes = [productsModel]()
    var productsDescription = String()
    var productPrice = String()
    var productSalePrice = String()
    var productTitle = String()
    var productID = Int()
    var isFavorite = Int()
    var colorID = Int()
    var hashColor = String()
    var currentIndex = 0
    var brandName = String()
    var sizeName = String()
    var imageGuide = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == false{
            let alert = UIAlertController.init(title: NSLocalizedString("Check your internet connection", comment: ""), message: "", preferredStyle: .alert)
            let dismissAction = UIAlertAction.init(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        self.activityIndicator.isHidden = true

        print(productTitle)
        print(productsDescription)
        print(productPrice)
        print(isFavorite)
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        sizesCollectionView.dataSource = self
        sizesCollectionView.delegate = self
        
        if isFavorite == 1{
            wishlistBtn.setTitleColor(.red, for: .normal)
            wishlistBtn.setTitle("REMOVE FROM WISHLIST", for: .normal)
        }else{
            wishlistBtn.setTitleColor(.black, for: .normal)
            wishlistBtn.setTitle("ADD TO WISHLIST", for: .normal)
        }
        
        self.productDescription.text = productsDescription
        self.price.text = productSalePrice
        self.productName.text = productTitle
        self.brand.text = brandName
        self.salePrice.text = productPrice
        
        addTitleImage()
        cartCounter()
        imagesHandleRefresh()
        colorsHandleRefresh()

    }
    override func viewDidAppear(_ animated: Bool) {
        addTitleImage()
        cartCounter()
        imagesHandleRefresh()
        colorsHandleRefresh()
    }
    
    @objc fileprivate func imagesHandleRefresh() {
        productApi.productImagesApi(id: productID) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.productImages = products
                self.pageControl.numberOfPages = self.productImages.count
                self.imagesCollectionView.reloadData()
            }
        }
    }

    @objc fileprivate func colorsHandleRefresh() {
        productApi.productColorsApi(id: productID) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.productColors = products
                self.colorsCollectionView.reloadData()
            }	
            self.addBadge()
        }
    }
    
    @objc fileprivate func sizesHandleRefresh() {
        productApi.productSizesApi(id: productID, color: hashColor) { (error: Error?, product: [productsModel]?) in
            if let products = product {
                self.sizes = products
                self.sizesCollectionView.reloadData()
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
        if let destenation = segue.destination as? sizesGuide{
            destenation.imageGuide = self.imageGuide
        }
    }
    
    @IBAction func addToCardBtn(_ sender: UIButton) {
        
            if self.colorID == 0{
                let alert = UIAlertController(title: NSLocalizedString("Please Select Color and Size", comment: ""), message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                cartApi.addCartApi(id: productID, color_id: colorID, size: sizeName) { (error: Error?, success: Bool?) in
                    
                    self.performSegue(withIdentifier: "cart", sender: nil)
                
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            }
    }
    
    @IBAction func addToWishlistBtn(_ sender: UIButton) {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()

        favoriteApi.setFavoriteApi(product_id: productID) { (error: Error?, status: Bool?, errorString: String?) in
            if status == true{
                if self.isFavorite == 0{
                    self.isFavorite = 1
                    self.wishlistBtn.setTitleColor(.red, for: .normal)
                    self.wishlistBtn.setTitle("REMOVE FROM WISHLIST", for: .normal)
                }else{
                    self.isFavorite = 0
                    self.wishlistBtn.setTitleColor(.black, for: .normal)
                    self.wishlistBtn.setTitle("ADD TO WISHLIST", for: .normal)
                }
            }else{
                print("\(error ?? "" as! Error)")
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
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
    
    var selectedRow = -1
}
    


extension productDetails : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imagesCollectionView{
            return productImages.count
        }else if collectionView == self.colorsCollectionView{
            return productColors.count
        }else{
            return sizes.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.imagesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsImagesCell", for: indexPath) as! detailsImagesCell
            let productData = productImages[indexPath.item]
            cell.configureCell(product: productData)
            return cell
        }

        else if collectionView == self.colorsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! colorCell
            let productData = productColors[indexPath.item]
            if selectedRow == indexPath.row {
                cell.colorView.layer.borderColor = UIColor.gray.cgColor
                cell.colorView.layer.borderWidth = 2
            }
            else {
                cell.layer.borderWidth = 0
            }
            cell.configureCell(product: productData)
            return cell
        }

        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsSizes", for: indexPath) as! detailsSizes
            let size = sizes[indexPath.item]
            cell.configureCell(product: size)
            return cell
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize.init(width: collectionView.frame.size.width, height: collectionView.frame.height)
        }else if collectionView.tag == 1{
            return CGSize.init(width: 40, height: 40)
        }else {
            return CGSize.init(width: 70, height: 30)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorsCollectionView{
            self.hashColor = productColors[indexPath.item].color
            self.sizesHandleRefresh()
        }
        if collectionView == sizesCollectionView{
            self.colorID = sizes[indexPath.item].id
            self.sizeName = sizes[indexPath.item].size
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1{
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
                let dataSourceCount = colorsCollectionView.dataSource?.collectionView(colorsCollectionView, numberOfItemsInSection: section),
                dataSourceCount > 0 else {
                    return .zero
            }

            let cellCount = CGFloat(dataSourceCount)
            let itemSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = flowLayout.itemSize.width + itemSpacing
            var insets = flowLayout.sectionInset

            let totalCellWidth = (cellWidth * cellCount) - itemSpacing
            let contentWidth = colorsCollectionView.frame.size.width - colorsCollectionView.contentInset.left - colorsCollectionView.contentInset.right

            guard totalCellWidth < contentWidth else {
                return insets
            }

            let padding = (contentWidth - totalCellWidth) / 2.0
            insets.left = padding
            insets.right = padding
            return insets
        }
        else if collectionView.tag == 2 {
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout,
                let dataSourceCount = sizesCollectionView.dataSource?.collectionView(sizesCollectionView, numberOfItemsInSection: section),
                dataSourceCount > 0 else {
                    return .zero
            }

            let cellCount = CGFloat(dataSourceCount)
            let itemSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = flowLayout.itemSize.width + itemSpacing
            var insets = flowLayout.sectionInset
            
            let totalCellWidth = (cellWidth * cellCount) - itemSpacing
            let contentWidth = sizesCollectionView.frame.size.width - sizesCollectionView.contentInset.left - sizesCollectionView.contentInset.right

            guard totalCellWidth < contentWidth else {
                return insets
            }
            let padding = (contentWidth - totalCellWidth) / 2.0
            insets.left = padding
            insets.right = padding
            return insets
        }
        else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 0{
            currentIndex = Int(scrollView.contentOffset.x / imagesCollectionView.frame.size.width)
            pageControl.currentPage = currentIndex
        }
    }
}
