//
//  LocalStorageManager.swift
//  Meli-Poc
//
//  Created by David Duarte on 18/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreData
import UIKit

// Local storage for save recent searches
class LocalStorageManager {
    
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    // MARK: get recent searches
    func fetchRecentSearches() throws -> [ProductSearched]? {
        do {
            let search: [ProductSearched] = try persistentContainer.viewContext.fetch(ProductSearched.fetchRequest())
            return search
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
           throw error
        }
    }
    // MARK: add searched product
    func addSearchedProduct(product: String){
        let productSearched = ProductSearched(entity: ProductSearched.entity(), insertInto: self.persistentContainer.viewContext)
        productSearched.title = product
        self.saveContext()
    }
    
    func saveContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
