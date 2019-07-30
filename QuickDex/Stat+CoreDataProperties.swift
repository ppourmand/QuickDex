//
//  Stat+CoreDataProperties.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/23/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//
//

import Foundation
import CoreData


extension Stat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stat> {
        return NSFetchRequest<Stat>(entityName: "Stat")
    }

    @NSManaged public var name: String?
    @NSManaged public var baseStat: String?

}
