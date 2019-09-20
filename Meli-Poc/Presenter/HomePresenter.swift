//
//  HomePresenter.swift
//  Meli-Poc
//
//  Created by David Duarte on 04/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol HomePresenterInterface: class {
    func getRecentSearches()
    func searchProducts(product: String, siteId: String)
    var presenterToViewProductFromApiSubject: PublishSubject<ProductResult> { get set }
    var presenterToViewSearchedProductSubject: PublishSubject<[ProductSearched]> { get set }
}

extension HomePresenterInterface {
    func searchProducts(
        product: String,
        siteId: String = "MLA") {
        return searchProducts(product: product, siteId: siteId)
    }
}

class HomePresenter {
    
    var presenterToViewProductFromApiSubject = PublishSubject<ProductResult>()
    var presenterToViewSearchedProductSubject = PublishSubject<[ProductSearched]>()
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    
    private let homeInteractor: HomeInteractorInterface
    private let homeRouter: HomeRouterInterface
    
    init(interactor: HomeInteractorInterface, router: HomeRouterInterface) {
        homeInteractor = interactor
        homeRouter = router
        subscribeToObserver(self.homeInteractor.interactorToPresenterSearchedProductSubject)
        subscribeToObserver(self.homeInteractor.interactorToPresenterProductFromApiSubject)
    }
}

extension HomePresenter: HomePresenterInterface {
    func getRecentSearches() {
        self.homeInteractor.fetchRecentSearches()
    }
    
    func searchProducts(product: String, siteId: String = "MLA") {
        self.homeInteractor.fetchProductFromApi(productForSearch: product, siteId: siteId)
    }
    
    
}

extension HomePresenter {
    func subscribeToObserver (_ subject: PublishSubject<[ProductSearched]>) {
        subject.subscribe(
            onNext: {(arraySearchedProducts) in
                self.presenterToViewSearchedProductSubject.onNext(arraySearchedProducts)
                
        },
            onError: {(error) in
                self.presenterToViewSearchedProductSubject.onError(error)
                self.homeRouter.navigateToErrorView(error: error)
        }).disposed(by: disposeBag)
    }
    
    func subscribeToObserver (_ subject: PublishSubject<ProductResult>) {
        subject.materialize()
            .subscribe(
                onNext: {(result) in
                    if let results = result.element {
                        self.presenterToViewProductFromApiSubject.onNext(results)
                        self.homeRouter.navigateToSearchedResults(products: results.results, title: results.query)
                    } else {
                        if let error = result.error {
                            self.homeRouter.navigateToErrorView(error: error)
                        }
                    }
            },
                onError: {(error) in
                    self.homeRouter.navigateToErrorView(error: error)
            },
                onCompleted: {() in
                    print("complete")
            }).disposed(by: disposeBag)
    }
}


