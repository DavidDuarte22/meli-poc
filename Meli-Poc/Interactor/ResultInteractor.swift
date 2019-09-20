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

protocol ResultInteractorInterface: class {
    func fetchProductDetail(productId: String)
    func navigateToProductDetail(product: ProductDetail)
    var interactorToPresenterProductDetailSubject: PublishSubject<ProductDetail> { get set }
}

class ResultInteractor {
    private var meliAPIURL: String = ""
    var interactorToPresenterProductDetailSubject = PublishSubject<ProductDetail>()
    private let httpClient = HttpClient.shared
    private let homeRouter = HomeRouter.shared
    
    init() {
        self.meliAPIURL = Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String
    }
}

extension ResultInteractor: ResultInteractorInterface {
    // navigate to product detail view
    func navigateToProductDetail(product: ProductDetail) {
        homeRouter.navigateToProductDetail(product: product)
    }
    // Get product detail from MELI API
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
