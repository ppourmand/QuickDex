//
//  PokeApi.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import NotificationBanner
import CoreData

class PokeApi: NSObject {
    
    let pokemonSearchEndpoint = "https://pokeapi.co/api/v2/pokemon/"
    static let sharedInstance = PokeApi()
    
    private override init() {}
    
    public func getPokemonData(pokemonName: String, uniqueID: UUID? = nil, completionHandler: @escaping (Bool, String) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if isValidInput(pokemonName) {
            let convertedPokemonName = convertUserInputToApiReadable(pokemonName)
            
            // check if we have the info saved even before making the API call
            do {
                let pokemonFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                
                // if a unique id was passed into the api call, its okay if pokemone duplicates exist in core data
                if let uuid = uniqueID {
                    pokemonFetchRequest.predicate = NSPredicate(format: "uniqueId == %@", uuid as CVarArg)
                }
                else {
                    pokemonFetchRequest.predicate = NSPredicate(format: "name == %@", convertedPokemonName)
                }

                let result = try managedContext.fetch(pokemonFetchRequest) as! [Pokemon]
                
                // if the count of entities after we've filtered for predicate matching on name has anything
                // in it, don't call the API and just return since we've already saved the pokemon
                if result.count == 1 {
                    print("pokemon with id \(convertedPokemonName) is already saved to core data")
                    completionHandler(true, convertedPokemonName)
                    return
                }
                else {
                    print("no such pokemon saved, calling API now")
                }
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            if let urlEndPoint = URL(string: pokemonSearchEndpoint + convertedPokemonName + "/") {
                Alamofire.request(urlEndPoint).responseJSON { response in
                    if let statusCode = response.response?.statusCode {
                        switch(statusCode) {
                        case 200:
                            print("Successfully returned API call")
                        case 404:
                            print("No such pokemon, error code: \(statusCode)")
                            StatusBarNotificationBanner(title: "No such Pokemon", style: .danger).show()
                            completionHandler(false, convertedPokemonName)
                        default:
                            print("error status code: \(statusCode)")
                            StatusBarNotificationBanner(title: "Error calling API: \(statusCode)", style: .danger).show()
                            return
                        }
                    }
                    if let result = response.result.value {
                        let jsonResponse = JSON(result)
                        let poke = Pokemon(context: managedContext)
                        
                        poke.uniqueId = uniqueID
                        
                        // sprites
                        let frontDefaultSprite = SpriteUrl(context: managedContext)
                        let frontFemaleSprite = SpriteUrl(context: managedContext)
                        let backDefaultSprite = SpriteUrl(context: managedContext)
                        let backFemaleSprite = SpriteUrl(context: managedContext)
                        
                        // grab the types
                        if jsonResponse["types"].count == 2 {
                            poke.typeOne = jsonResponse["types"][0]["type"]["name"].stringValue
                            poke.typeTwo = jsonResponse["types"][1]["type"]["name"].stringValue
                        }
                        else {
                            poke.typeOne = jsonResponse["types"][0]["type"]["name"].stringValue
                        }
                        
                        // set the values of type effectiveness of the pokemon
                        self.setWeaknesses(pokemonToSet: poke, managedContext)
                                                
                        // grab the dex number
                        poke.numberId = jsonResponse["id"].stringValue
                        
                        // grab the stats
                        for statistic in jsonResponse["stats"] {
                            let stat = Stat(context: managedContext)
                            stat.baseStat = statistic.1["base_stat"].stringValue
                            stat.name = statistic.1["stat"]["name"].stringValue
                            poke.addToStats(stat)
                        }
                        
                        // grab the name
                        poke.name = jsonResponse["name"].stringValue
                        
                        // grab the sprites
                        frontDefaultSprite.url = jsonResponse["sprites"]["front_default"].stringValue
                        frontFemaleSprite.url = jsonResponse["sprites"]["front_female"].stringValue
                        backDefaultSprite.url = jsonResponse["sprites"]["back_default"].stringValue
                        backFemaleSprite.url = jsonResponse["sprites"]["back_female"].stringValue
                        
                        frontDefaultSprite.direction = "frontDefault"
                        frontFemaleSprite.direction = "frontFemale"
                        backDefaultSprite.direction = "backDefault"
                        backFemaleSprite.direction = "backFemale"
                        
                        poke.addToSprites(frontDefaultSprite)
                        poke.addToSprites(frontFemaleSprite)
                        poke.addToSprites(backDefaultSprite)
                        poke.addToSprites(backFemaleSprite)
                        
                        // save state
                        do {
                            try managedContext.save()
                            print("saved pokemon: \(poke.name!)")
                            
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                        completionHandler(true, convertedPokemonName)
                        
                    }
                    
                }
                
            }
            else {
                let failBanner = StatusBarNotificationBanner(title: "Bad Input", style: .danger)
                failBanner.show()
            }
        }
        else {
            let failBanner = StatusBarNotificationBanner(title: "Bad Input", style: .danger)
            failBanner.show()
        }
        
    }
    
    private func isValidInput(_ inputPokemon: String) -> Bool{
        // we should do input validation here
        // if it contains any special character, return bad input
        // if the length is > 100, return "input too long"
        // if its just all empty spaces, return bad input
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ -’.'")
        let invertedCharacterSet = characterset.inverted
        var lastOccurredSpecialCharacter = Unicode.Scalar(0)
        var occurencesOfSpecialCharacter: Int = 0
        
        if inputPokemon.isEmpty || inputPokemon.count > 100 {
            return false
        }
        
        if inputPokemon.rangeOfCharacter(from: invertedCharacterSet) != nil {
            return false
        }
        
        for character in inputPokemon.unicodeScalars {
            
            if occurencesOfSpecialCharacter > 1 && character == lastOccurredSpecialCharacter {
                return false
            }
            
            if invertedCharacterSet.contains(character) || character == " " {
                lastOccurredSpecialCharacter = character
                occurencesOfSpecialCharacter += 1
            }
            else {
                occurencesOfSpecialCharacter = 0
            }
        }
        
        return true
    }
    
    private func convertUserInputToApiReadable(_ userInput: String) -> String {
        var convertedOutput = ""
        convertedOutput = userInput.replacingOccurrences(of: " ", with: "-").lowercased()
        convertedOutput = convertedOutput.replacingOccurrences(of: "’", with: "")
        convertedOutput = convertedOutput.replacingOccurrences(of: ".", with: "")
        convertedOutput = convertedOutput.replacingOccurrences(of: "'", with: "")
        return convertedOutput
    }
    
    func setWeaknesses(pokemonToSet: Pokemon, _ managedContext: NSManagedObjectContext ) {
        let types = [pokemonToSet.typeOne, pokemonToSet.typeTwo]
        
        // type effectivenesses
        let normal = Type(context: managedContext)
        let fighting = Type(context: managedContext)
        let flying = Type(context: managedContext)
        let poison = Type(context: managedContext)
        let ground = Type(context: managedContext)
        let rock = Type(context: managedContext)
        let bug = Type(context: managedContext)
        let ghost = Type(context: managedContext)
        let steel = Type(context: managedContext)
        let fire = Type(context: managedContext)
        let water = Type(context: managedContext)
        let grass = Type(context: managedContext)
        let electric = Type(context: managedContext)
        let psychic = Type(context: managedContext)
        let ice = Type(context: managedContext)
        let dragon = Type(context: managedContext)
        let dark = Type(context: managedContext)
        let fairy = Type(context: managedContext)
        let unknown = Type(context: managedContext)
        
        // set up effectiveness names
        normal.name = "normal"
        fighting.name = "fighting"
        flying.name = "flying"
        poison.name = "poison"
        ground.name = "ground"
        rock.name = "rock"
        bug.name = "bug"
        ghost.name = "ghost"
        steel.name = "steel"
        fire.name = "fire"
        water.name = "water"
        grass.name = "grass"
        electric.name = "electric"
        psychic.name = "psychic"
        ice.name = "ice"
        dragon.name = "dragon"
        dark.name = "dark"
        fairy.name = "fairy"
        unknown.name = "unknown"
        
        // initial values for effectiveness
        normal.effectiveness = 1.0
        fighting.effectiveness = 1.0
        flying.effectiveness = 1.0
        poison.effectiveness = 1.0
        ground.effectiveness = 1.0
        rock.effectiveness = 1.0
        bug.effectiveness = 1.0
        ghost.effectiveness = 1.0
        steel.effectiveness = 1.0
        fire.effectiveness = 1.0
        water.effectiveness = 1.0
        grass.effectiveness = 1.0
        electric.effectiveness = 1.0
        psychic.effectiveness = 1.0
        ice.effectiveness = 1.0
        dragon.effectiveness = 1.0
        dark.effectiveness = 1.0
        fairy.effectiveness = 1.0
        unknown.effectiveness = 1.0
        
        for type in types {
            switch type {
            case "normal":
                fighting.effectiveness *= 2.0
                ghost.effectiveness = 0.0
            case "fighting":
                flying.effectiveness *= 2.0
                psychic.effectiveness *= 2.0
                fairy.effectiveness *= 2.0
                rock.effectiveness *= 0.5
                bug.effectiveness *= 0.5
                dark.effectiveness *= 0.5
            case "flying":
                fighting.effectiveness *= 0.5
                ground.effectiveness = 0.0
                rock.effectiveness *= 2.0
                bug.effectiveness *= 0.5
                grass.effectiveness *= 0.5
                electric.effectiveness *= 2.0
                ice.effectiveness *= 2.0
            case "poison":
                fighting.effectiveness *= 0.5
                poison.effectiveness *= 0.5
                ground.effectiveness *= 2.0
                bug.effectiveness *= 0.5
                grass.effectiveness *= 0.5
                psychic.effectiveness *= 2.0
                fairy.effectiveness *= 0.5
            case "ground":
                poison.effectiveness *= 0.5
                rock.effectiveness *= 0.5
                water.effectiveness *= 2.0
                grass.effectiveness *= 2.0
                electric.effectiveness = 0.0
                ice.effectiveness *= 2.0
            case "rock":
                normal.effectiveness *= 0.5
                fighting.effectiveness *= 2.0
                flying.effectiveness *= 0.5
                poison.effectiveness *= 0.5
                ground.effectiveness *= 2.0
                steel.effectiveness *= 2.0
                fire.effectiveness *= 0.5
                water.effectiveness *= 2.0
                grass.effectiveness *= 2.0
            case "bug":
                fighting.effectiveness *= 0.5
                flying.effectiveness *= 2.0
                ground.effectiveness *= 0.5
                rock.effectiveness *= 2.0
                fire.effectiveness *= 2.0
                grass.effectiveness *= 0.5
            case "ghost":
                normal.effectiveness = 0.0
                fighting.effectiveness = 0.0
                poison.effectiveness *= 0.5
                bug.effectiveness *= 0.5
                ghost.effectiveness *= 2.0
                dark.effectiveness *= 2.0
            case "steel":
                normal.effectiveness *= 0.5
                fighting.effectiveness *= 2.0
                flying.effectiveness *= 0.5
                poison.effectiveness = 0.0
                ground.effectiveness *= 2.0
                rock.effectiveness *= 0.5
                bug.effectiveness *= 0.5
                steel.effectiveness *= 0.5
                fire.effectiveness *= 2.0
                grass.effectiveness *= 0.5
                psychic.effectiveness *= 0.5
                ice.effectiveness *= 0.5
                dragon.effectiveness *= 0.5
                fairy.effectiveness *= 0.5
            case "fire":
                ground.effectiveness *= 2.0
                rock.effectiveness *= 2.0
                bug.effectiveness *= 0.5
                steel.effectiveness *= 0.5
                fire.effectiveness *= 0.5
                water.effectiveness *= 2.0
                grass.effectiveness *= 0.5
                ice.effectiveness *= 0.5
                fairy.effectiveness *= 0.5
            case "water":
                steel.effectiveness *= 0.5
                fire.effectiveness *= 0.5
                water.effectiveness *= 0.5
                grass.effectiveness *= 2.0
                electric.effectiveness *= 2.0
                ice.effectiveness *= 0.5
            case "grass":
                flying.effectiveness *= 2.0
                poison.effectiveness *= 2.0
                ground.effectiveness *= 0.5
                bug.effectiveness *= 2.0
                fire.effectiveness *= 2.0
                water.effectiveness *= 0.5
                grass.effectiveness *= 0.5
                electric.effectiveness *= 0.5
                ice.effectiveness *= 2.0
            case "electric":
                flying.effectiveness *= 0.5
                ground.effectiveness *= 2.0
                steel.effectiveness *= 0.5
                electric.effectiveness *= 0.5
            case "psychic":
                fighting.effectiveness *= 0.5
                bug.effectiveness *= 2.0
                ghost.effectiveness *= 2.0
                psychic.effectiveness *= 0.5
                dark.effectiveness *= 2.0
            case "ice":
                fighting.effectiveness *= 2.0
                rock.effectiveness *= 2.0
                steel.effectiveness *= 2.0
                fire.effectiveness *= 2.0
                ice.effectiveness *= 0.5
            case "dragon":
                fire.effectiveness *= 0.5
                water.effectiveness *= 0.5
                grass.effectiveness *= 0.5
                electric.effectiveness *= 0.5
                ice.effectiveness *= 2.0
                dragon.effectiveness *= 2.0
                fairy.effectiveness *= 2.0
            case "dark":
                fighting.effectiveness *= 2.0
                bug.effectiveness *= 2.0
                ghost.effectiveness *= 0.5
                psychic.effectiveness = 0.0
                dark.effectiveness *= 0.5
                fairy.effectiveness *= 2.0
            case "fairy":
                fighting.effectiveness *= 0.5
                poison.effectiveness *= 2.0
                bug.effectiveness *= 0.5
                steel.effectiveness *= 2.0
                dragon.effectiveness = 0.0
                dark.effectiveness *= 0.5
            case "unknown":
                fallthrough
            case "shadow":
                fallthrough
            default:
                print("There was a type case we didnt catch (possibly only 1 type)")
            }
        }
        
        // add type effectiveness to pokemon
        pokemonToSet.addToTypeEffectiveness(normal)
        pokemonToSet.addToTypeEffectiveness(fighting)
        pokemonToSet.addToTypeEffectiveness(flying)
        pokemonToSet.addToTypeEffectiveness(poison)
        pokemonToSet.addToTypeEffectiveness(ground)
        pokemonToSet.addToTypeEffectiveness(rock)
        pokemonToSet.addToTypeEffectiveness(bug)
        pokemonToSet.addToTypeEffectiveness(ghost)
        pokemonToSet.addToTypeEffectiveness(steel)
        pokemonToSet.addToTypeEffectiveness(fire)
        pokemonToSet.addToTypeEffectiveness(water)
        pokemonToSet.addToTypeEffectiveness(grass)
        pokemonToSet.addToTypeEffectiveness(electric)
        pokemonToSet.addToTypeEffectiveness(psychic)
        pokemonToSet.addToTypeEffectiveness(ice)
        pokemonToSet.addToTypeEffectiveness(dragon)
        pokemonToSet.addToTypeEffectiveness(fairy)
        pokemonToSet.addToTypeEffectiveness(dark)
        pokemonToSet.addToTypeEffectiveness(unknown)
    }
   
}
