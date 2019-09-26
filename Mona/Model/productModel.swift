//
//  productsModel.swift
//  Style Cosmetics
//
//  Created by Tariq on 7/25/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SwiftyJSON

class productsModel: NSObject {
    
    var photo: String
    var title: String
    var price: String
    var salePrice: String
    var productDescription: String
    var shortDescription: String
    var id: Int
    var color: String
    var colorID: Int
    var unitPrice: String
    var totalUnitPrice: Int
    var isFavorite: Int
    var wishList: String
    var productName: String
    var counter: String
    var cartID: Int
    var username: String
    var rateRange: String
    var rateComment: String
    var orderID: Int
    var orderPrice: String
    var orderState: String
    var orderDate: String
    var deleveryFees: String
    var taxs: Int
    var address: String
    var city: String
    var country: String
    var street : String
    var productPrice: String
    var productQuantity: String
    var productID: String
    var productID1: String
    var productName1: String
    var rateAvrg: Double
    var customerName: String
    var customerPhone: String
    var customerEmail: String
    var size: String
    var brand: String
    var imageGuide: String
    
    
    init?(dict:[String: JSON]){
        
        if let photo = dict["image"]?.string{
            self.photo = photo
        }else{
            self.photo = ""
        }
        
        if let id = dict["id"]?.int {
            self.id = id
        }else{
            self.id = 0
        }
        
        if let title = dict["title"]?.string{
            self.title = title
        }else{
            self.title = ""
        }
        
        if let price = dict["price_general"]?.string {
            self.price = price
        }else {
            self.price = ""
        }
        
        if let salePrice = dict["sale_price"]?.string {
            self.salePrice = salePrice
        }else {
            self.salePrice = ""
        }
        
        
        if let description = dict["description"]?.string {
            self.productDescription = description
        }else{
            self.productDescription = ""
        }
        
        if let shortDescription = dict["short_description"]?.string {
            self.shortDescription = shortDescription
        }else{
            self.shortDescription = ""
        }
        
        if let hashColor = dict["hash_color"]?.string{
            self.color = hashColor
        }else{
            self.color = ""
        }
        
        if let unitPrice = dict["unit_price"]?.string {
            self.unitPrice = unitPrice
        }else {
            self.unitPrice = ""
        }
        
        if let totalUnitPrice = dict["total_unit_price"]?.int {
            self.totalUnitPrice = totalUnitPrice
        }else {
            self.totalUnitPrice = 0
        }
        
        if let productName = dict["product_name"]?.string {
            self.productName = productName
        }else {
            self.productName = ""
        }
        
        if let counter = dict["quantity"]?.string {
            self.counter = counter
        }else {
            self.counter = ""
        }
        
        if let cartID = dict["cart_id"]?.int {
            self.cartID = cartID
        }else{
            self.cartID = 0
        }
        
        if let isFavorite = dict["Wishlist_state"]?.int{
            self.isFavorite = isFavorite
        }else{
            self.isFavorite = 0
        }
        
        if let wishList = dict["Wishlist_state"]?.string{
            self.wishList = wishList
        }else{
            self.wishList = ""
        }
        
        if let colorID = dict["id"]?.int{
            self.colorID = colorID
        }else{
            self.colorID = 0
        }
        
        if let username = dict["user_name"]?.string{
            self.username = username
        }else{
            self.username = ""
        }
        
        if let rateRange = dict["rate_range"]?.string{
            self.rateRange = rateRange
        }else{
            self.rateRange = ""
        }
        
        if let rateComment = dict["rate_comment"]?.string{
            self.rateComment = rateComment
        }else{
            self.rateComment = ""
        }
        
        if let orderID = dict["order_id"]?.int{
            self.orderID = orderID
        }else{
            self.orderID = 0
        }
        
        if let orderPrice = dict["order_total_price"]?.string{
            self.orderPrice = orderPrice
        }else{
            self.orderPrice = ""
        }
        
        if let orderState = dict["order_stat"]?.string{
            self.orderState = orderState
        }else{
            self.orderState = ""
        }
        
        if let orderDate = dict["created_at"]?.string{
            self.orderDate = orderDate
        }else{
            self.orderDate = ""
        }
        
        if let deleveryFees = dict["delevery_fees"]?.string{
            self.deleveryFees = deleveryFees
        }else{
            self.deleveryFees = ""
        }
        
        if let taxs = dict["tax"]?.int{
            self.taxs = taxs
        }else{
            self.taxs = 0
        }
        
        if let address = dict["customer_address"]?.string{
            self.address = address
        }else{
            self.address = ""
        }
        if let city = dict["customer_city"]?.string{
            self.city = city
        }else{
            self.city = ""
        }
        
        if let country = dict["customer_country"]?.string{
            self.country = country
        }else{
            self.country = ""
        }
        
        if let street = dict["customer_street"]?.string{
            self.street = street
        }else{
            self.street = ""
        }
        
        if let productPrice = dict["product_price"]?.string{
            self.productPrice = productPrice
        }else{
            self.productPrice = ""
        }
        
        if let productQuantity = dict["product_quantity"]?.string{
            self.productQuantity = productQuantity
        }else{
            self.productQuantity = ""
        }
        
        if let productID = dict["id"]?.string {
            self.productID = productID
        }else{
            self.productID = ""
        }
        
        if let productID1 = dict["product_id"]?.string {
            self.productID1 = productID1
        }else{
            self.productID1 = ""
        }
        
        if let productName1 = dict["name"]?.string {
            self.productName1 = productName1
        }else {
            self.productName1 = ""
        }
        
        if let rateAvrg = dict["rates"]?.double {
            self.rateAvrg = rateAvrg
        }else{
            self.rateAvrg = 0
        }
        
        if let customerName = dict["name"]?.string{
            self.customerName = customerName
        }else{
            self.customerName = ""
        }
        
        if let customerPhone = dict["phone"]?.string{
            self.customerPhone = customerPhone
        }else{
            self.customerPhone = ""
        }
        
        if let customerEmail = dict["email"]?.string{
            self.customerEmail = customerEmail
        }else{
            self.customerEmail = ""
        }
        
        if let size = dict["size"]?.string{
            self.size = size
        }else{
            self.size = ""
        }
        
        if let brand = dict["brand_name"]?.string{
            self.brand = brand
        }else{
            self.brand = ""
        }
        
        if let imageGuide = dict["image_guide"]?.string{
            self.imageGuide = imageGuide
        }else{
            self.imageGuide = ""
        }
    }
}
