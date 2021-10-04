//
//  Item+CoreDataProperties.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/4/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?

}

extension Item : Identifiable {

}
