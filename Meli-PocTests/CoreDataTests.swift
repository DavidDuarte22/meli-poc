//
//  CoreDataTests.swift
//  Meli-PocTests
//
//  Created by David Duarte on 18/09/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import Foundation
import XCTest
import CoreData

@testable import Meli_Poc

class CoreDataTests: XCTestCase {
    
    var coreData: LocalStorageManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ProductSearched", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    
    func initStubs() {
        
        func insertProduct( product: String ) -> ProductSearched? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "ProductSearched", into: mockPersistantContainer.viewContext)
            
            obj.setValue(product, forKey: "title")
            
            return obj as? ProductSearched
        }
        
        insertProduct(product: "Macbook pro")
        insertProduct(product: "Iphone")
        insertProduct(product: "Nike")
        insertProduct(product: "Iphone 5")
        insertProduct(product: "Adidas futbol 5 pelota y string largo")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }
        
    }
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductSearched")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    override func tearDown() {
        flushData() // Clear all stubs
        super.tearDown()
    }
    
    override func setUp() {
        super.setUp()
        initStubs()
        coreData = LocalStorageManager(container: mockPersistantContainer)
    }
    
    
    func test_fetch_all_todo() {
        //Given a storage with two todo
        //When fetch
        
        
        do {
            let results = try coreData.fetchRecentSearches()
        
            //Assert return five todo items
            XCTAssertEqual(results!.count, 5)
        } catch let error as NSError {
            print("Couldn't fetch. \(error), \(error.userInfo)")
            
        }
        
    }
    
    //    func test_create_todo() {
    //
    //        //Given the name & status
    //        let title = "Macbook pro"
    //
    //        //When add todo
    //        let todo = coreData.addSearchedProduct(product: title)
    //
    //        //Assert: return todo item
    //        XCTAssertNotNil( todo )
    //
    //    }

}
