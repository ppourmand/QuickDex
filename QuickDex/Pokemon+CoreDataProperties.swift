//
//  Pokemon+CoreDataProperties.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/23/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var numberId: String?
    @NSManaged public var typeOne: String?
    @NSManaged public var typeTwo: String?
    @NSManaged public var uniqueId: UUID?
    @NSManaged public var stats: NSSet?
    @NSManaged public var typeEffectiveness: NSSet?
    @NSManaged public var sprites: NSSet?

}

// MARK: Generated accessors for stats
extension Pokemon {

    @objc(addStatsObject:)
    @NSManaged public func addToStats(_ value: Stat)

    @objc(removeStatsObject:)
    @NSManaged public func removeFromStats(_ value: Stat)

    @objc(addStats:)
    @NSManaged public func addToStats(_ values: NSSet)

    @objc(removeStats:)
    @NSManaged public func removeFromStats(_ values: NSSet)

}

// MARK: Generated accessors for typeEffectiveness
extension Pokemon {

    @objc(addTypeEffectivenessObject:)
    @NSManaged public func addToTypeEffectiveness(_ value: Type)

    @objc(removeTypeEffectivenessObject:)
    @NSManaged public func removeFromTypeEffectiveness(_ value: Type)

    @objc(addTypeEffectiveness:)
    @NSManaged public func addToTypeEffectiveness(_ values: NSSet)

    @objc(removeTypeEffectiveness:)
    @NSManaged public func removeFromTypeEffectiveness(_ values: NSSet)

}

// MARK: Generated accessors for sprites
extension Pokemon {

    @objc(addSpritesObject:)
    @NSManaged public func addToSprites(_ value: SpriteUrl)

    @objc(removeSpritesObject:)
    @NSManaged public func removeFromSprites(_ value: SpriteUrl)

    @objc(addSprites:)
    @NSManaged public func addToSprites(_ values: NSSet)

    @objc(removeSprites:)
    @NSManaged public func removeFromSprites(_ values: NSSet)

}
