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
    var statViewController: PokemonStatsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PokeApi.sharedInstance.getPokemonData(pokemonName: "magikarp", completionHandler: {(success, pokemon) in
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
                
                for (name, stat) in pokemon.stats {
                    print("\(name): \(stat.baseStat)")
                }
                
                
                self.statViewController?.setStats(attackStat: pokemon.stats["attack"]!.baseStat, healthStat: pokemon.stats["hp"]!.baseStat, defenseStat: pokemon.stats["defense"]!.baseStat, specialAttackStat: pokemon.stats["special-attack"]!.baseStat, specialDefenseStat: pokemon.stats["special-defense"]!.baseStat, speedStat: pokemon.stats["speed"]!.baseStat)
                
                // downloads the sprite and displays it in the imageview
                let frontSpriteUrl = URL(string: pokemon.sprites.frontDefault)!
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
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "statsSegue") {
            self.statViewController = segue.destination as? PokemonStatsTableViewController
        }
    }
}
