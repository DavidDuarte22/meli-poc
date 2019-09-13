//
//  Address.swift
//  Meli-Poc
//
//  Created by David Duarte on 07/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct Address: Codable {
    var state_name: String
    var city_name: String
    
    init(state_name: String, city_name: String) {
        self.state_name = state_name
        self.city_name = city_name
    }
}

/* Mock Address
 
 "address": {
 "state_id": "AR-B",
 "state_name": "Buenos Aires",
 "city_id": null,
 "city_name": "Villa Martelli"
 },
 
 */
