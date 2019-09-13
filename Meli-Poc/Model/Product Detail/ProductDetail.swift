//
//  ProductDetail.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct ProductDetail: Codable {
    var id: String
    var title: String
    var price: Double
    var currency_id: String
    var category_id: String
    var available_quantity: Int
    var seller_address: SellerAddress
    var condition: String
    var shipping: Shipping
    var pictures: [Picture]
    
    init(id: String, title: String, price: Double, currency_id: String, category_id: String, available_quantity: Int, seller_address: SellerAddress, condition: String, shipping: Shipping, pictures: [Picture]) {
        self.id = id
        self.title = title
        self.price = price
        self.currency_id = currency_id
        self.category_id = category_id
        self.available_quantity = available_quantity
        self.seller_address = seller_address
        self.condition = condition
        self.shipping = shipping
        self.pictures = pictures
    }
}
