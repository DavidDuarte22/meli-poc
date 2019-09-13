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

class ResultPresenter {
    private var meliAPIURL: String = ""
    var presenterProductDetailSubject = PublishSubject<ProductDetail>()
    let httpClient = HttpClient.shared
    
    init() {
        self.meliAPIURL = Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String
    }
    
    func getProductDetail(productId: String) {
        httpClient.callGet(
            serviceUrl: "\(meliAPIURL)/items/\(productId)",
            success: { (product: ProductDetail, response: HttpResponse?) in
                self.presenterProductDetailSubject.onNext(product)
        },
            failure: { (error: Error, response: HttpResponse?) in
                print(error)
                self.presenterProductDetailSubject.onError(error)
        })
    }
    
    func showProductDetail(product: ProductDetail, navigationController: UINavigationController) {
        navigationController.pushViewController(ResultDetailView(product: product), animated: false)
    }
}
