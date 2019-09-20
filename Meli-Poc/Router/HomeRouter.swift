//
//  HomeRouter.swift
//  Meli-Poc
//
//  Created by David Duarte on 17/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit

protocol HomeRouterInterface: class {
    func navigateToSearchedResults(products: [Product], title: String)
    func setRootView(rootViewController: UITableViewController) -> UINavigationController
    func navigateToProductDetail(product: ProductDetail)
    func navigateToErrorView(error: Error)
}

class HomeRouter {
    // private init for singleton router
    public static let shared = HomeRouter()
    private var navigationController = UINavigationController()
    
    private init() {
        
    }
    
}

extension HomeRouter: HomeRouterInterface {
    func setRootView(rootViewController: UITableViewController) -> UINavigationController {
        navigationController = UINavigationController(rootViewController: rootViewController)
        return navigationController
    }
    
    // Navigate to ResultsTable with results of search
    func navigateToSearchedResults(products: [Product], title: String) {
        // implementar e instanciar router de Result
        let resultInteractor = ResultInteractor()
        let resultRouter = HomeRouter.shared
        let resultPresenter: ResultPresenterInterface = ResultPresenter(interactor: resultInteractor, router: resultRouter)
        navigationController.pushViewController(ResultsTableView(results: products, query: title, presenter: resultPresenter), animated: false)
    }
    
    // Navigate to product detail
    func navigateToProductDetail(product: ProductDetail) {
        navigationController.pushViewController(ResultDetailView(product: product), animated: false)
    }
    
    // Navigate to error view
    func navigateToErrorView(error: Error) {
        let meliError = ErrorHandler().tableError(error: error)
        let errorView = ErrorView(error: meliError)
        navigationController.present(errorView, animated: true, completion: nil)
    }
}
