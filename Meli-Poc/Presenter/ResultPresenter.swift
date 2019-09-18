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
}

class ResultPresenter {
    var presenterToViewProductDetailSubject = PublishSubject<ProductDetail>()
    
    let resultInteractor = ResultInteractor()
    let homeRouter = HomeRouter.shared
    // disposeBag for RxSwift
    let disposeBag = DisposeBag()
    
    init() {
        subscribeToObserver(self.resultInteractor.interactorToPresenterProductDetailSubject)
    }
}

extension ResultPresenter {
    func getProductDetail(productId: String) {
        resultInteractor.fetchProductDetail(productId: productId)
    }
    
    func showProductDetail(product: ProductDetail) {
        homeRouter.navigateToProductDetail(product: product)
    }
}

extension ResultPresenter {
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
