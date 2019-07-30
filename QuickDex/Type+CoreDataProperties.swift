//
//  Type+CoreDataProperties.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/23/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//
//

import Foundation
import CoreData


extension Type {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: "Type")
    }

    @NSManaged public var name: String?
    @NSManaged public var effectiveness: Double

}
