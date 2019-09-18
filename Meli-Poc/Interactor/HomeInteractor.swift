//
//  HomeInteractor.swift
//  Meli-Poc
//
//  Created by David Duarte on 17/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import networkLayer
import SystemConfiguration

protocol HomeInteractorInterface {
    func fetchRecentSearches()
    func fetchProductFromApi(productForSearch product: String, siteId: String)
}

class HomeInteractor {
    private var meliAPIURL: String = ""
    private let httpClient = HttpClient.shared
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchedProducts: [ProductSearched]?
    
    var interactorToPresenterSearchedProductSubject = PublishSubject<[ProductSearched]>()
    var interactorToPresenterProductFromApiSubject = PublishSubject<ProductResult>()
    var interactorToPresenterErrorSubject = PublishSubject<Error>()
    
    init() {
        self.meliAPIURL = Bundle.main.infoDictionary?["MELI_API_ENDPOINT"] as! String
    }
    func networkMiddleware() -> (availableNetwork: Bool, error: Error?) {
        do {
            let _ = try ReachabilityController().checkReachable()
            return (true, nil)
        } catch let error as MeliError {
            self.interactorToPresenterErrorSubject.onNext(error)
            return (false, error)
        }
        catch {
            let error = MeliError.defaultError
            self.interactorToPresenterErrorSubject.onNext(error)
            return (false, error)
        }
    }
}

extension HomeInteractor: HomeInteractorInterface {
    func fetchRecentSearches() {
        do {
            let search: [ProductSearched] = try context.fetch(ProductSearched.fetchRequest())
            self.searchedProducts = search
            self.interactorToPresenterSearchedProductSubject.onNext(search)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
            self.interactorToPresenterSearchedProductSubject.onError(error)
        }
    }
    
    func fetchProductFromApi(productForSearch product: String, siteId: String = "MLA") {
        if let error = networkMiddleware().error {
            self.interactorToPresenterErrorSubject.onNext(error)
            return
        }
        
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
                self.interactorToPresenterProductFromApiSubject.onNext(arrayResult)
        },
            failure: { (error: Error, response: HttpResponse?) in
                self.interactorToPresenterProductFromApiSubject.onError(error)
        })
    }
}

extension HomeInteractor {
    // trim and replace whitespace in string inserted by user
    func prepareString(searchString: String) -> String {
        var polishedString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        polishedString = polishedString.replacingOccurrences(of: " ", with: "+")
        return polishedString
    }
}
