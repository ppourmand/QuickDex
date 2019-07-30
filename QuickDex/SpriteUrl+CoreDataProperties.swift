//
//  SpriteUrl+CoreDataProperties.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/23/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//
//

import Foundation
import CoreData


extension SpriteUrl {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpriteUrl> {
        return NSFetchRequest<SpriteUrl>(entityName: "SpriteUrl")
    }

    @NSManaged public var url: String?
    @NSManaged public var direction: String?

}
