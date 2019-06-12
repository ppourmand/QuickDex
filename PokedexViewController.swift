//
//  PokedexViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDexNumberLabel: UILabel!
    @IBOutlet weak var pokemonTypeOneLabel: UILabel!
    @IBOutlet weak var pokemonTypeTwoLabel: UILabel!
    @IBOutlet weak var pokemonStatsTableView: UIView!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    
    var currentPokemon: Pokemon?
    var currentSpriteIndex: Int = 0
    var statViewController: PokemonStatsTableViewController?
    
    @IBAction func tappedSprite(_ sender: Any) {
        
        if self.currentSpriteIndex == 3 {
            self.currentSpriteIndex = 0
        }
        else {
            self.currentSpriteIndex += 1
        }
        
        self.downloadAndDisplaySprite(pokemonSpriteUrl: (currentPokemon?.sprites.set[self.currentSpriteIndex])!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PokeApi.sharedInstance.getPokemonData(pokemonName: "hitmonlee", completionHandler: {(success, pokemon) in
            if (!success) {
                print("Error calling API")
            }
            else {
                self.currentPokemon = pokemon
                self.pokemonNameLabel.text = pokemon.name
                self.pokemonDexNumberLabel.text = "#\(pokemon.number)"
                
                if pokemon.types.count == 2 {
                    self.pokemonTypeOneLabel.text = pokemon.types[0].name
                    self.pokemonTypeTwoLabel.text = pokemon.types[1].name
                }
                else if pokemon.types.count == 1 {
                    self.pokemonTypeOneLabel.text = pokemon.types[0].name
                    self.pokemonTypeTwoLabel.text = ""
                }
                else {
                    self.pokemonTypeOneLabel.text = ""
                    self.pokemonTypeTwoLabel.text = ""
                }
                
                self.statViewController?.setStats(attackStat: pokemon.stats["attack"]!.baseStat, healthStat: pokemon.stats["hp"]!.baseStat, defenseStat: pokemon.stats["defense"]!.baseStat, specialAttackStat: pokemon.stats["special-attack"]!.baseStat, specialDefenseStat: pokemon.stats["special-defense"]!.baseStat, speedStat: pokemon.stats["speed"]!.baseStat)
                
                // downloads the sprite and displays it in the imageview
                self.downloadAndDisplaySprite(pokemonSpriteUrl: pokemon.sprites.frontDefault)
                
                print(self.currentPokemon?.typeEffectiveness)
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "statsSegue") {
            self.statViewController = segue.destination as? PokemonStatsTableViewController
        }
    }
    
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


