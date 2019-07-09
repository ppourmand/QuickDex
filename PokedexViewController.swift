//
//  PokedexViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit
import NotificationBanner

class PokedexViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDexNumberLabel: UILabel!
    @IBOutlet weak var pokemonTypeOneLabel: UILabel!
    @IBOutlet weak var pokemonTypeTwoLabel: UILabel!
    @IBOutlet weak var pokemonStatsTableView: UIView!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!

    @IBOutlet weak var pokemonSearchField: UITextField!
    
    var currentPokemon: Pokemon?
    var currentSpriteIndex: Int = 0
    var statViewController: PokemonStatsTableViewController?
    var typeEffectivenessViewController: TypesTableViewController?
    var matchupViewController: MatchupTableViewController?
    
    @IBAction func tappedSprite(_ sender: Any) {
        
        if self.currentSpriteIndex == ((currentPokemon?.sprites.set.count)! - 1) {
            self.currentSpriteIndex = 0
        }
        else {
            self.currentSpriteIndex += 1
        }
        
        self.downloadAndDisplaySprite(pokemonSpriteUrl: (currentPokemon?.sprites.set[self.currentSpriteIndex])!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonSearchField.delegate = self
        
        PokeApi.sharedInstance.getPokemonData(pokemonName: "bulbasaur", completionHandler: {(success, pokemon) in
            if (!success) {
                print("Error calling API")
            }
            else {
                if let pokemon = pokemon {
                    self.currentPokemon = pokemon
                    self.matchupViewController?.searchedPokemon = pokemon
                    self.matchupViewController?.tableView.reloadData()
                    
                    var prettyPokemonName = pokemon.name.replacingOccurrences(of: "-", with: " ")
                    prettyPokemonName = prettyPokemonName.capitalized
                    self.pokemonNameLabel.text = prettyPokemonName
                    self.pokemonDexNumberLabel.text = "National Dex: #\(pokemon.number)"
                    
                    if pokemon.types.count == 2 {
                        self.pokemonTypeOneLabel.text = pokemon.types[0].name.capitalized
                        self.pokemonTypeTwoLabel.text = pokemon.types[1].name.capitalized
                    }
                    else if pokemon.types.count == 1 {
                        self.pokemonTypeOneLabel.text = pokemon.types[0].name.capitalized
                        self.pokemonTypeTwoLabel.text = ""
                    }
                    else {
                        self.pokemonTypeOneLabel.text = ""
                        self.pokemonTypeTwoLabel.text = ""
                    }
                    
                    self.statViewController?.setStats(attackStat: pokemon.stats["attack"]!.baseStat, healthStat: pokemon.stats["hp"]!.baseStat, defenseStat: pokemon.stats["defense"]!.baseStat, specialAttackStat: pokemon.stats["special-attack"]!.baseStat, specialDefenseStat: pokemon.stats["special-defense"]!.baseStat, speedStat: pokemon.stats["speed"]!.baseStat)
                    
                    // downloads the sprite and displays it in the imageview
                    self.downloadAndDisplaySprite(pokemonSpriteUrl: pokemon.sprites.frontDefault)
                    
                    self.typeEffectivenessViewController?.setEffectivenessValues(normalEffectiveness: pokemon.typeEffectiveness["normal"]!, fireEffectiveness: pokemon.typeEffectiveness["fire"]!, waterEffectiveness: pokemon.typeEffectiveness["water"]!, fightingEffectiveness: pokemon.typeEffectiveness["fighting"]!, grassEffectiveness: pokemon.typeEffectiveness["grass"]!, flyingEffectiveness: pokemon.typeEffectiveness["flying"]!, electricEffectiveness: pokemon.typeEffectiveness["electric"]!, poisonEffectiveness: pokemon.typeEffectiveness["poison"]!, psychicEffectiveness: pokemon.typeEffectiveness["psychic"]!, groundEffectiveness: pokemon.typeEffectiveness["ground"]!, iceEffectiveness: pokemon.typeEffectiveness["ice"]!, rockEffectiveness: pokemon.typeEffectiveness["rock"]!, dragonEffectiveness: pokemon.typeEffectiveness["dragon"]!, bugEffectiveness: pokemon.typeEffectiveness["bug"]!, darkEffectiveness: pokemon.typeEffectiveness["dark"]!, ghostEffectiveness: pokemon.typeEffectiveness["ghost"]!, fairyEffectiveness: pokemon.typeEffectiveness["fairy"]!, steelEffectiveness: pokemon.typeEffectiveness["steel"]!)
                }
                else {
                    let failBanner = StatusBarNotificationBanner(title: "Unable to find Pokemon", style: .danger)
                    failBanner.show()
                }
            }
            
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "statsSegue") {
            self.statViewController = segue.destination as? PokemonStatsTableViewController
        }
        if (segue.identifier == "typeEffectivenessSegue") {
            self.typeEffectivenessViewController = segue.destination as? TypesTableViewController
        }
        if (segue.identifier == "matchupSegue") {
            self.matchupViewController = segue.destination as? MatchupTableViewController
        }
    }
    
    @IBAction func searchPokedex(_ sender: Any) {
                
        if var pokemonToSearch = self.pokemonSearchField.text {
            print(pokemonToSearch)
            
            pokemonToSearch = pokemonToSearch.replacingOccurrences(of: " ", with: "-")
            PokeApi.sharedInstance.getPokemonData(pokemonName: pokemonToSearch, completionHandler: {(success, pokemon) in
                if (!success) {
                    print("Error calling API")
                }
                else {
                    if let pokemon = pokemon {
                        self.currentPokemon = pokemon
                        self.matchupViewController?.searchedPokemon = pokemon
                        self.matchupViewController?.tableView.reloadData()

                        var prettyPokemonName = pokemon.name.replacingOccurrences(of: "-", with: " ")
                        prettyPokemonName = prettyPokemonName.capitalized
                        self.pokemonNameLabel.text = prettyPokemonName
                        self.pokemonDexNumberLabel.text = "National Dex: #\(pokemon.number)"
                        
                        if pokemon.types.count == 2 {
                            self.pokemonTypeOneLabel.text = pokemon.types[0].name.capitalized
                            self.pokemonTypeTwoLabel.text = pokemon.types[1].name.capitalized
                        }
                        else if pokemon.types.count == 1 {
                            self.pokemonTypeOneLabel.text = pokemon.types[0].name.capitalized
                            self.pokemonTypeTwoLabel.text = " "
                        }
                        else {
                            self.pokemonTypeOneLabel.text = " "
                            self.pokemonTypeTwoLabel.text = " "
                        }
                        
                        self.statViewController?.setStats(attackStat: pokemon.stats["attack"]!.baseStat, healthStat: pokemon.stats["hp"]!.baseStat, defenseStat: pokemon.stats["defense"]!.baseStat, specialAttackStat: pokemon.stats["special-attack"]!.baseStat, specialDefenseStat: pokemon.stats["special-defense"]!.baseStat, speedStat: pokemon.stats["speed"]!.baseStat)
                        
                        // downloads the sprite and displays it in the imageview
                        self.downloadAndDisplaySprite(pokemonSpriteUrl: pokemon.sprites.frontDefault)
                        
                        self.typeEffectivenessViewController?.setEffectivenessValues(normalEffectiveness: pokemon.typeEffectiveness["normal"]!, fireEffectiveness: pokemon.typeEffectiveness["fire"]!, waterEffectiveness: pokemon.typeEffectiveness["water"]!, fightingEffectiveness: pokemon.typeEffectiveness["fighting"]!, grassEffectiveness: pokemon.typeEffectiveness["grass"]!, flyingEffectiveness: pokemon.typeEffectiveness["flying"]!, electricEffectiveness: pokemon.typeEffectiveness["electric"]!, poisonEffectiveness: pokemon.typeEffectiveness["poison"]!, psychicEffectiveness: pokemon.typeEffectiveness["psychic"]!, groundEffectiveness: pokemon.typeEffectiveness["ground"]!, iceEffectiveness: pokemon.typeEffectiveness["ice"]!, rockEffectiveness: pokemon.typeEffectiveness["rock"]!, dragonEffectiveness: pokemon.typeEffectiveness["dragon"]!, bugEffectiveness: pokemon.typeEffectiveness["bug"]!, darkEffectiveness: pokemon.typeEffectiveness["dark"]!, ghostEffectiveness: pokemon.typeEffectiveness["ghost"]!, fairyEffectiveness: pokemon.typeEffectiveness["fairy"]!, steelEffectiveness: pokemon.typeEffectiveness["steel"]!)
                    }
                    else    {
                        let failBanner = StatusBarNotificationBanner(title: "Unable to find Pokemon", style: .danger)
                        failBanner.show()
                    }
                }
                
            })
        }
    }
    
    // hides keyboard after pressing search and clears the field
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //self.view.endEditing(true)
//        //textField.text = ""
//        textField.resignFirstResponder()
//        return false
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        pokemonSearchField.text = ""
//    }

    
    func downloadAndDisplaySprite(pokemonSpriteUrl: String) {
        if !pokemonSpriteUrl.isEmpty {
            let frontSpriteUrl = URL(string: pokemonSpriteUrl)!
            URLSession.shared.dataTask(with: frontSpriteUrl as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print(error ?? "No Error")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    self.pokemonSpriteImageView.image = image
                })
                
            }).resume()
        }
    }
}


