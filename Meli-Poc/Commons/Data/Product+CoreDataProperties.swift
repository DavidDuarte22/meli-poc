//
//  Product+CoreDataProperties.swift
//  
//
//  Created by David Duarte on 09/09/2019.
//
//

import Foundation
import CoreData


extension ProductSearched {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductSearched> {
        return NSFetchRequest<ProductSearched>(entityName: "ProductSearched")
    }

    @NSManaged public var title: String?

}
