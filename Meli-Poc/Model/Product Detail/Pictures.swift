//
//  Pictures.swift
//  Meli-Poc
//
//  Created by David Duarte on 09/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation

struct Picture: Codable {
    var id: String
    var secure_url: String
    
    init(id: String, secure_url: String) {
        self.id = id
        self.secure_url = secure_url
    }
}



/* Mock Picture:
{
    "id": "835825-MLA31010847309_062019",
    "url": "http://mla-s2-p.mlstatic.com/835825-MLA31010847309_062019-O.jpg",
    "secure_url": "https://mla-s2-p.mlstatic.com/835825-MLA31010847309_062019-O.jpg",
    "size": "500x387",
    "max_size": "834x646",
    "quality": ""
},
*/
