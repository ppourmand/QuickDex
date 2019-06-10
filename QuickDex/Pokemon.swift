//
//  Pokemon.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/4/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pokemon {
    var name: String
    var number: String
    var types: [Type]
    var stats: [String: Stat]
    var sprites: SpriteSet
//    var abilities: [Ability]
//    var moves: [Move]
//    var locationAreaEncountersUrl: String
    
    init(name: String, number: String, types: [Type], stats: [String: Stat], sprites: SpriteSet) {
        self.name = name
        self.number = number
        self.types = types
        self.sprites = sprites
        self.stats = stats
//        self.abilities = abilities
//        self.moves = moves
//        self.locationAreaEncountersUrl = locationAreaEncountersUrl
    }
}

struct Ability {
    var name: String
    var url: String
    var isHidden: Bool
    var slot: Int
    
    init(name: String, url: String, isHidden: Bool, slot: Int) {
        self.name = name
        self.url = url
        self.isHidden = isHidden
        self.slot = slot
    }
}

struct Move {
    var name: String
    var url: String
    var levelLearnedAt: Int
    var methodLearned: String
    var versionLearnedIn: String
    
    init(name: String, url: String, levelLearnedAt: Int, methodLearned: String, versionLearnedIn: String) {
        self.name = name
        self.url = url
        self.levelLearnedAt = levelLearnedAt
        self.methodLearned = methodLearned
        self.versionLearnedIn = versionLearnedIn
    }
}

struct SpriteSet {
    var backDefault: String
    var backFemale: String
    var frontDefault: String
    var frontFemale: String
    
    init(backDefault: String, backFemale: String, frontDefault: String, frontFemale: String) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
    }
}

struct Stat {
    var name: String
    var baseStat: String
    var effort: String
    
    init(_ name: String, _ baseStat: String, _ effort: String) {
        self.name = name
        self.baseStat = baseStat
        self.effort = effort
    }
}

struct Type {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
