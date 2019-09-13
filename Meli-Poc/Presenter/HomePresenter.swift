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
import networkLayer

class HomePresenter {
    
    private var meliAPIURL: String = ""
    var presenterProductSubject = PublishSubject<ProductResult>()
    var presenterSearchedProductArraySubject = PublishSubject<[ProductSearched]>()
    let httpClient = HttpClient.shared
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchedProducts: [ProductSearched]?
    
    init() {
        self.meliAPIURL = Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String
    }
    
    // MARK: Retrieve from CoreData
    func retrieveRecentSearches() {
        do {
            let search: [ProductSearched] = try context.fetch(ProductSearched.fetchRequest())
            self.searchedProducts = search
            self.presenterSearchedProductArraySubject.onNext(search)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
            self.presenterSearchedProductArraySubject.onError(error)
        }
    }
    // MARK: Search
    func searchProduct(product: String, siteId: String = "MLA") {
        let searchText = prepareString(searchString: product)
        httpClient.callGet(
            serviceUrl: "\(meliAPIURL)/sites/\(siteId)/search?q=\(searchText)",
            success: { (arrayResult: ProductResult, response: HttpResponse?) in
                // save in CoreData the product searched if it isn't
                if self.searchedProducts != nil {
                    let results = self.searchedProducts!.filter { $0.title == product }
                    if results.isEmpty {
                        let productSearched = ProductSearched(entity: ProductSearched.entity(), insertInto: self.context)
                        productSearched.title = product
                        self.appDelegate.saveContext()
                    }
                }
                // lanzar evento para acrtualizar la view
                self.presenterProductSubject.onNext(arrayResult)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.presenterProductSubject.onError(error)
        })
    }
    // Navigate to ResultsTable with results of search
    func showSearchedResults(products: [Product], title: String, navigationController: UINavigationController) {
        navigationController.pushViewController(ResultsTableView(results: products, query: title), animated: false)
    }
}

extension HomePresenter {
    // trim and replace whitespace in string inserted by user
    func prepareString(searchString: String) -> String {
        var polishedString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        polishedString = polishedString.replacingOccurrences(of: " ", with: "+")
        return polishedString
    }
}
