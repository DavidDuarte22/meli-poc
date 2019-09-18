//
//  Meli_PocTests.swift
//  Meli-PocTests
//
//  Created by David Duarte on 04/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import XCTest
@testable import Meli_Poc

class Meli_PocTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testProductSetGet() {
        let product = Product(id: "MLA786117240",
                              title: "iPod Touch 5ta Generación 32 Gigas",
                              price: 3300.00,
                              currency_id: "ARS",
                              category_id: "",
                              thumbnail: "http://mla-s1-p.mlstatic.com/743054-MLA28371111319_102018-I.jpg",
                              address: Address(state_name: "Buenos Aires", city_name: "Villa Martelli"),
                              shipping: Shipping(free_shipping: false))
        
                XCTAssertEqual(product.id, "MLA786117240")
                XCTAssertEqual(product.title, "iPod Touch 5ta Generación 32 Gigas")
                XCTAssertEqual(product.price, 3300.00)
                XCTAssertEqual(product.currency_id, "ARS")
                XCTAssertEqual(product.category_id, "")
                XCTAssertEqual(product.thumbnail, "http://mla-s1-p.mlstatic.com/743054-MLA28371111319_102018-I.jpg")
                XCTAssertEqual(product.address.state_name, "Buenos Aires")
                XCTAssertEqual(product.address.city_name, "Villa Martelli")
                XCTAssertEqual(product.shipping.free_shipping, false)
        
        //        XCTAssertEqual(movie.imageName, "avatar")
    }
    
}
