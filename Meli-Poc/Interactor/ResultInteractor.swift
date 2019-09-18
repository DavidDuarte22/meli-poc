//
//  ResultPresenter.swift
//  Meli-Poc
//
//  Created by David Duarte on 17/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import RxSwift
import networkLayer

protocol ResultInteractorInterface {
    func fetchProductDetail(productId: String)
    func navigateToProductDetail(product: ProductDetail)
}

class ResultInteractor {
    private var meliAPIURL: String = ""
    var interactorToPresenterProductDetailSubject = PublishSubject<ProductDetail>()
    let httpClient = HttpClient.shared
    let homeRouter = HomeRouter.shared
    
    init() {
        self.meliAPIURL = Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String
    }
}

extension ResultInteractor: ResultInteractorInterface {
    func navigateToProductDetail(product: ProductDetail) {
        homeRouter.navigateToProductDetail(product: product)
    }
    
    func fetchProductDetail(productId: String) {
        httpClient.callGet(
            serviceUrl: "\(meliAPIURL)/items/\(productId)",
            success: { (product: ProductDetail, response: HttpResponse?) in
                self.interactorToPresenterProductDetailSubject.onNext(product)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.interactorToPresenterProductDetailSubject.onError(error)
        })
    }
}
