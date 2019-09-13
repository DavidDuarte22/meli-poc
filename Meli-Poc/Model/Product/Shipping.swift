//
//  Shipping.swift
//  Meli-Poc
//
//  Created by David Duarte on 07/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct Shipping: Codable {
    var free_shipping: Bool
    
    init(free_shipping: Bool) {
        self.free_shipping = free_shipping
    }
    
}


/* Mock
 
 "shipping": {
 "free_shipping": true,
 "mode": "me2",
 "tags": [],
 "logistic_type": "drop_off",
 "store_pick_up": false
 },
 
 */
