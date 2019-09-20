//
//  ResultPresenter.swift
//  Meli-Poc
//
//  Created by David Duarte on 11/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import RxSwift
import networkLayer

protocol ResultPresenterInterface {
    func getProductDetail(productId: String)
    func showProductDetail(product: ProductDetail)
    var presenterToViewProductDetailSubject: PublishSubject<ProductDetail> { get set }
}

class ResultPresenter {
    var presenterToViewProductDetailSubject = PublishSubject<ProductDetail>()
    
    private let resultInteractor: ResultInteractorInterface
    private let homeRouter: HomeRouterInterface
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    
    init(interactor: ResultInteractorInterface, router: HomeRouterInterface) {
        resultInteractor = interactor
        homeRouter = router
        subscribeToObserver(self.resultInteractor.interactorToPresenterProductDetailSubject)
    }
}

extension ResultPresenter: ResultPresenterInterface {
    // MARK: get product detail
    func getProductDetail(productId: String) {
        resultInteractor.fetchProductDetail(productId: productId)
    }
    // MARK: show product detail
    func showProductDetail(product: ProductDetail) {
        homeRouter.navigateToProductDetail(product: product)
    }
}

extension ResultPresenter {
    // subscribe to observer whose will get the product detail
    func subscribeToObserver (_ subject: PublishSubject<ProductDetail>) {
        subject.subscribe(
            onNext: {(productDetail) in
                self.presenterToViewProductDetailSubject.onNext(productDetail)
                self.showProductDetail(product: productDetail)
        },
            onError: {(error) in
                self.presenterToViewProductDetailSubject.onError(error)
                self.homeRouter.navigateToErrorView(error: error)
        }).disposed(by: disposeBag)
    }
}
