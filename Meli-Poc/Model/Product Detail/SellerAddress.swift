//
//  SellerAddress.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct SellerAddress: Codable {
    var city: City
    var state: State
    var country: Country
    
    init(city: City, state: State, country: Country) {
        self.city = city
        self.state = state
        self.country = country
    }
}

struct City: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct State: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Country: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

/* Mock Seller Address
 
 "seller_address": {
 "city": {
 "id": "TUxBQkNBQjM4MDda",
 "name": "Caballito"
 },
 "state": {
 "id": "AR-C",
 "name": "Capital Federal"
 },
 "country": {
 "id": "AR",
 "name": "Argentina"
 },
 "search_location": {
 "neighborhood": {
 "id": "TUxBQkNBQjM4MDda",
 "name": "Caballito"
 },
 "city": {
 "id": "TUxBQ0NBUGZlZG1sYQ",
 "name": "Capital Federal"
 },
 "state": {
 "id": "TUxBUENBUGw3M2E1",
 "name": "Capital Federal"
 }
 },
 "latitude": -34.625313,
 "longitude": -58.4339,
 "id": 242722326
 },

*/
