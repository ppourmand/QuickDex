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

class PokeApi: NSObject {
    
    let pokemonSearchEndpoint = "https://pokeapi.co/api/v2/pokemon/"
    static let sharedInstance = PokeApi()
    
    private override init() {}
    
    public func getPokemonData(pokemonName: String, completionHandler: @escaping (Bool, Pokemon?) -> Void) {
        
        if isValidInput(pokemonName) {
            let convertedPokemonName = convertUserInputToApiReadable(pokemonName)
            if let urlEndPoint = URL(string: pokemonSearchEndpoint + convertedPokemonName + "/") {
                Alamofire.request(urlEndPoint).responseJSON { response in
                    if let statusCode = response.response?.statusCode {
                        switch(statusCode) {
                        case 200:
                            print("Successfully returned API call")
                        case 404:
                            print("No such pokemon, error code: \(statusCode)")
                            completionHandler(true, nil )
                        default:
                            print("error status code: \(statusCode)")
                            return
                        }
                    }
                    if let result = response.result.value {
                        let jsonResponse = JSON(result)
                        
                        var types: [Type] = []
                        var stats: [String: Stat] = [:]
                        var pokemonId: String
                        var sprites: SpriteSet
                        
                        // grab the types
                        for type in jsonResponse["types"] {
                            types.append(Type(name: JSON(type.1)["type"]["name"].stringValue))
                        }
                        
                        // grab the dex number
                        pokemonId = jsonResponse["id"].stringValue
                        
                        // grab the stats
                        for stat in jsonResponse["stats"] {
                            let base = stat.1["base_stat"].stringValue
                            let name = stat.1["stat"]["name"].stringValue
                            let effort = stat.1["effort"].stringValue
                            stats[name] = Stat(name, base, effort)
                        }
                        
                        // grab the name
                        let name = jsonResponse["name"].stringValue
                        
                        // grab the sprites
                        let frontDefault = jsonResponse["sprites"]["front_default"].stringValue
                        let frontFemale = jsonResponse["sprites"]["front_female"].stringValue
                        let backDefault = jsonResponse["sprites"]["back_default"].stringValue
                        let backFemale = jsonResponse["sprites"]["back_female"].stringValue
                        
                        sprites = SpriteSet(backDefault: backDefault, backFemale: backFemale, frontDefault: frontDefault, frontFemale: frontFemale)
                        
                        completionHandler(true, Pokemon(name, pokemonId, types, stats , sprites) )
                        
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
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -’.'")
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
}
