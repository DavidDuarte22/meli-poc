//
//  HomeInteractorTests.swift
//  Meli-PocTests
//
//  Created by David Duarte on 18/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import XCTest
@testable import Meli_Poc

class HomeInteractorTests: XCTestCase {
    
    class FakeInteractionOutput: HomeInteractorTests {
        var searchedProducts: [ProductSearched]?
        
        
    }
    
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}

extension HomeInteractorTests: HomeInteractorInterface {
    func fetchRecentSearches() {
        <#code#>
    }
    
    func fetchProductFromApi(productForSearch product: String, siteId: String) {
        <#code#>
    }
    
    var interactorToPresenterSearchedProductSubject: PublishSubject<[ProductSearched]> {
        get {
            <#code#>
        }
        set(newValue) {
            <#code#>
        }
    }
    
    var interactorToPresenterProductFromApiSubject: PublishSubject<ProductResult> {
        get {
            <#code#>
        }
        set(newValue) {
            <#code#>
        }
    }
    
    
}
