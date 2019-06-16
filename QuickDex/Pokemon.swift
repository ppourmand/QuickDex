//
//  Pokemon.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/4/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pokemon {
    var name: String = ""
    var number: String = ""
    var types: [Type] = []
    var stats: [String: Stat]
    var sprites: SpriteSet
    var typeEffectiveness = [String:Double]()
//    var abilities: [Ability]
//    var moves: [Move]
//    var locationAreaEncountersUrl: String
    
    
    init(_ name: String, _ number: String, _ types: [Type], _ stats: [String: Stat], _ sprites: SpriteSet) {
        self.name = name
        self.number = number
        self.types = types
        self.sprites = sprites
        self.stats = stats
        self.typeEffectiveness["normal"] = 1.0
        self.typeEffectiveness["fighting"] = 1.0
        self.typeEffectiveness["flying"] = 1.0
        self.typeEffectiveness["poison"] = 1.0
        self.typeEffectiveness["ground"] = 1.0
        self.typeEffectiveness["rock"] = 1.0
        self.typeEffectiveness["bug"] = 1.0
        self.typeEffectiveness["ghost"] = 1.0
        self.typeEffectiveness["steel"] = 1.0
        self.typeEffectiveness["fire"] = 1.0
        self.typeEffectiveness["water"] = 1.0
        self.typeEffectiveness["grass"] = 1.0
        self.typeEffectiveness["electric"] = 1.0
        self.typeEffectiveness["psychic"] = 1.0
        self.typeEffectiveness["ice"] = 1.0
        self.typeEffectiveness["dragon"] = 1.0
        self.typeEffectiveness["dark"] = 1.0
        self.typeEffectiveness["fairy"] = 1.0
        self.typeEffectiveness["unknown"] = 1.0
        self.typeEffectiveness["shadow"] = 1.0
        
        self.setWeaknesses()
//        self.abilities = abilities
//        self.moves = moves
//        self.locationAreaEncountersUrl = locationAreaEncountersUrl
    }
    
    func setWeaknesses() {
        for type in self.types {
            switch type.name {
            case "normal":
                self.typeEffectiveness["fighting"]! *= 2.0
                self.typeEffectiveness["ghost"] = 0.0
            case "fighting":
                self.typeEffectiveness["flying"]! *= 2.0
                self.typeEffectiveness["psychic"]! *= 2.0
                self.typeEffectiveness["fairy"]! *= 2.0
                self.typeEffectiveness["rock"]! *= 0.5
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["dark"]! *= 0.5
            case "flying":
                self.typeEffectiveness["fighting"]! *= 0.5
                self.typeEffectiveness["ground"]! = 0.0
                self.typeEffectiveness["rock"]! *= 2.0
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["electric"]! *= 2.0
                self.typeEffectiveness["ice"]! *= 2.0
            case "poison":
                self.typeEffectiveness["fighting"]! *= 0.5
                self.typeEffectiveness["poison"]! *= 0.5
                self.typeEffectiveness["ground"]! *= 2.0
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["psychic"]! *= 2.0
                self.typeEffectiveness["fairy"]! *= 0.5
            case "ground":
                self.typeEffectiveness["poison"]! *= 0.5
                self.typeEffectiveness["rock"]! *= 0.5
                self.typeEffectiveness["water"]! *= 2.0
                self.typeEffectiveness["grass"]! *= 2.0
                self.typeEffectiveness["electric"]! = 0.0
                self.typeEffectiveness["ice"]! *= 2.0
            case "rock":
                self.typeEffectiveness["normal"]! *= 0.5
                self.typeEffectiveness["fighting"]! *= 2.0
                self.typeEffectiveness["flying"]! *= 0.5
                self.typeEffectiveness["poison"]! *= 0.5
                self.typeEffectiveness["ground"]! *= 2.0
                self.typeEffectiveness["steel"]! *= 2.0
                self.typeEffectiveness["fire"]! *= 0.5
                self.typeEffectiveness["water"]! *= 2.0
                self.typeEffectiveness["grass"]! *= 2.0
            case "bug":
                self.typeEffectiveness["fighting"]! *= 0.5
                self.typeEffectiveness["flying"]! *= 2.0
                self.typeEffectiveness["ground"]! *= 0.5
                self.typeEffectiveness["rock"]! *= 2.0
                self.typeEffectiveness["fire"]! *= 2.0
                self.typeEffectiveness["grass"]! *= 0.5
            case "ghost":
                self.typeEffectiveness["normal"]! = 0.0
                self.typeEffectiveness["fighting"]! = 0.0
                self.typeEffectiveness["poison"]! *= 0.5
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["ghost"]! *= 2.0
                self.typeEffectiveness["dark"]! *= 2.0
            case "steel":
                self.typeEffectiveness["normal"]! *= 0.5
                self.typeEffectiveness["fighting"]! *= 2.0
                self.typeEffectiveness["flying"]! *= 0.5
                self.typeEffectiveness["poison"]! = 0.0
                self.typeEffectiveness["ground"]! *= 2.0
                self.typeEffectiveness["rock"]! *= 0.5
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["steel"]! *= 0.5
                self.typeEffectiveness["fire"]! *= 2.0
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["psychic"]! *= 0.5
                self.typeEffectiveness["ice"]! *= 0.5
                self.typeEffectiveness["dragon"]! *= 0.5
                self.typeEffectiveness["fairy"]! *= 0.5
            case "fire":
                self.typeEffectiveness["ground"]! *= 2.0
                self.typeEffectiveness["rock"]! *= 2.0
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["steel"]! *= 0.5
                self.typeEffectiveness["fire"]! *= 0.5
                self.typeEffectiveness["water"]! *= 2.0
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["ice"]! *= 0.5
                self.typeEffectiveness["fairy"]! *= 0.5
            case "water":
                self.typeEffectiveness["steel"]! *= 0.5
                self.typeEffectiveness["fire"]! *= 0.5
                self.typeEffectiveness["water"]! *= 0.5
                self.typeEffectiveness["grass"]! *= 2.0
                self.typeEffectiveness["electric"]! *= 2.0
                self.typeEffectiveness["ice"]! *= 0.5
            case "grass":
                self.typeEffectiveness["flying"]! *= 2.0
                self.typeEffectiveness["poison"]! *= 2.0
                self.typeEffectiveness["ground"]! *= 0.5
                self.typeEffectiveness["bug"]! *= 2.0
                self.typeEffectiveness["fire"]! *= 2.0
                self.typeEffectiveness["water"]! *= 0.5
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["electric"]! *= 0.5
                self.typeEffectiveness["ice"]! *= 2.0
            case "electric":
                self.typeEffectiveness["flying"]! *= 0.5
                self.typeEffectiveness["ground"]! *= 2.0
                self.typeEffectiveness["steel"]! *= 0.5
                self.typeEffectiveness["electric"]! *= 0.5
            case "psychic":
                self.typeEffectiveness["fighting"]! *= 0.5
                self.typeEffectiveness["bug"]! *= 2.0
                self.typeEffectiveness["ghost"]! *= 2.0
                self.typeEffectiveness["psychic"]! *= 0.5
                self.typeEffectiveness["dark"]! *= 2.0
            case "ice":
                self.typeEffectiveness["fighting"]! *= 2.0
                self.typeEffectiveness["rock"]! *= 2.0
                self.typeEffectiveness["steel"]! *= 2.0
                self.typeEffectiveness["fire"]! *= 2.0
                self.typeEffectiveness["ice"]! *= 0.5
            case "dragon":
                self.typeEffectiveness["fire"]! *= 0.5
                self.typeEffectiveness["water"]! *= 0.5
                self.typeEffectiveness["grass"]! *= 0.5
                self.typeEffectiveness["electric"]! *= 0.5
                self.typeEffectiveness["ice"]! *= 2.0
                self.typeEffectiveness["dragon"]! *= 2.0
                self.typeEffectiveness["fairy"]! *= 2.0
            case "dark":
                self.typeEffectiveness["fighting"]! *= 2.0
                self.typeEffectiveness["bug"]! *= 2.0
                self.typeEffectiveness["ghost"]! *= 0.5
                self.typeEffectiveness["psychic"]! = 0.0
                self.typeEffectiveness["dark"]! *= 0.5
                self.typeEffectiveness["fairy"]! *= 2.0
            case "fairy":
                self.typeEffectiveness["fighting"]! *= 0.5
                self.typeEffectiveness["poison"]! *= 2.0
                self.typeEffectiveness["bug"]! *= 0.5
                self.typeEffectiveness["steel"]! *= 2.0
                self.typeEffectiveness["dragon"]! = 0.0
                self.typeEffectiveness["dark"]! *= 0.5
            case "unknown":
                fallthrough
            case "shadow":
                fallthrough
            default:
                print("There was a type case we didnt catch")
            }
        }
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
    var backDefault: String = ""
    var backFemale: String = ""
    var frontDefault: String = ""
    var frontFemale: String = ""
    var set: [String] = []
    
    init(backDefault: String, backFemale: String, frontDefault: String, frontFemale: String) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        
        self.set.append(frontDefault)
        self.set.append(backDefault)
        self.set.append(frontFemale)
        self.set.append(backFemale)
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
