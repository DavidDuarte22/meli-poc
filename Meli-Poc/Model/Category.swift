//
//  Category.swift
//  Meli-Poc
//
//  Created by David Duarte on 06/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct Category: Codable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
