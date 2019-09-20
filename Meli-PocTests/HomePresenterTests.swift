//
//  HomePresenterTests.swift
//  Meli-PocTests
//
//  Created by David Duarte on 19/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import Meli_Poc

class HomePresenterTests: XCTestCase {
    var presenter: HomePresenterInterface!
    var interactor: TestHomeInteractor!
    var router: TestHomeRouter!
    
    override func setUp() {
        super.setUp()
        
        interactor = TestHomeInteractor()
        router = TestHomeRouter()
        presenter = HomePresenter(interactor: interactor, router: router)
    }
}

extension HomePresenterTests {
    class TestHomeRouter: HomeRouterInterface {
        var showSearchedResults = false
        var showProductDetail = false
        var showError = false
        
        func navigateToSearchedResults(products: [Product], title: String) {
            showSearchedResults = true
        }
        
        func setRootView(rootViewController: UITableViewController) -> UINavigationController {
            return UINavigationController()
        }
        
        func navigateToProductDetail(product: ProductDetail) {
            showSearchedResults = true
        }
        
        func navigateToErrorView(error: Error) {
            showError = true
        }
    }
    
    class TestHomeInteractor: HomeInteractorInterface {
        let disposeBag = DisposeBag()
        func fetchRecentSearches() {
            
        }
        
        func fetchProductFromApi(productForSearch product: String, siteId: String) {
            
        }
        
        var interactorToPresenterSearchedProductSubject: PublishSubject<[ProductSearched]>
        
        var interactorToPresenterProductFromApiSubject: PublishSubject<ProductResult>
        
        
    }
}
