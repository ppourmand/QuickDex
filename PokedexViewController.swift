//
//  PokedexViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit
import NotificationBanner

class AutocompleteCell: UITableViewCell {
    @IBOutlet weak var pokemonNameLabel: UILabel!
}

class PokedexViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if autocompleteSuggestions.count > 5 {
            return 5
        }
        return autocompleteSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "autocompleteName") as! AutocompleteCell
        
        cell.pokemonNameLabel?.text = autocompleteSuggestions[indexPath.row]
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            cell.backgroundColor = DARK_MODE_BAR_COLOR
            cell.pokemonNameLabel.textColor = UIColor.white
        }
        else {
            cell.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0) /* #ededed */
            cell.pokemonNameLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellWhereIsTheLabel = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! AutocompleteCell
        self.pokemonSearchField.text = cellWhereIsTheLabel.pokemonNameLabel.text
        self.autocompleteTableView.isHidden = true
        self.searchPokedex(self)
    }
    
    // keeping track of autocomplete stuff
    var autocompleteSuggestions: [String] = []
    
    @IBOutlet weak var autocompleteTableView: UITableView!
    
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDexNumberLabel: UILabel!
    @IBOutlet weak var pokemonTypeOneLabel: UILabel!
    @IBOutlet weak var pokemonTypeTwoLabel: UILabel!
    @IBOutlet weak var pokemonStatsTableView: UIView!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pokemonSearchField: UITextField!
    @IBOutlet weak var baseStatsLabel: UILabel!
    @IBOutlet weak var typeEffectivenessLabel: UILabel!
    @IBOutlet weak var typeMatchupsLabel: UILabel!
    
    var currentPokemon: Pokemon?
    var currentSpriteIndex: Int = 0
    var statViewController: PokemonStatsTableViewController?
    var typeEffectivenessViewController: TypesTableViewController?
    var matchupViewController: MatchupTableViewController?
    @IBOutlet weak var navigationBar: UINavigationBar!

    
    @IBAction func tappedSprite(_ sender: Any) {
        if (currentPokemon?.sprites.set.count)! != 0 {
            if self.currentSpriteIndex == ((currentPokemon?.sprites.set.count)! - 1) {
                self.currentSpriteIndex = 0
            }
            else {
                self.currentSpriteIndex += 1
            }
            self.downloadAndDisplaySprite(pokemonSpriteUrl: (currentPokemon?.sprites.set[self.currentSpriteIndex])!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // here is the block of code for dark/light modes
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            print("enable dark mode")
            self.tabBarController?.tabBar.barTintColor = DARK_MODE_BAR_COLOR
            self.tabBarController?.tabBar.isTranslucent = false
            self.containerView.backgroundColor = UIColor.black
            self.pokemonNameLabel.textColor = UIColor.white
            self.pokemonDexNumberLabel.textColor = UIColor.white
            self.pokemonTypeOneLabel.textColor = UIColor.white
            self.pokemonTypeTwoLabel.textColor = UIColor.white
            self.baseStatsLabel.textColor = UIColor.white
            self.typeEffectivenessLabel.textColor = UIColor.white
            self.typeMatchupsLabel.textColor = UIColor.white
            self.pokemonSearchField.backgroundColor = UIColor.darkGray
            self.pokemonSearchField.textColor = UIColor.white
            self.pokemonSearchField.attributedPlaceholder = NSAttributedString(string: "Name or pokedex number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            self.pokemonSpriteImageView.backgroundColor = UIColor.black
            self.pokemonSearchField.keyboardAppearance = .dark
            self.navigationBar.barTintColor = DARK_MODE_BAR_COLOR
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.view.backgroundColor = DARK_MODE_BAR_COLOR
            self.scrollView.backgroundColor = UIColor.black
        }
        else {
            print("enable light mode")
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.containerView.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
            self.navigationBar.barTintColor = UIColor.white
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            self.pokemonNameLabel.textColor = UIColor.black
            self.pokemonDexNumberLabel.textColor = UIColor.black
            self.pokemonTypeOneLabel.textColor = UIColor.black
            self.pokemonTypeTwoLabel.textColor = UIColor.black
            self.baseStatsLabel.textColor = UIColor.black
            self.typeEffectivenessLabel.textColor = UIColor.black
            self.typeMatchupsLabel.textColor = UIColor.black
            self.pokemonSearchField.backgroundColor = UIColor.white
            self.pokemonSearchField.textColor = UIColor.black
            self.pokemonSearchField.attributedPlaceholder = NSAttributedString(string: "Name or pokedex number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.pokemonSpriteImageView.backgroundColor = UIColor.white
            self.pokemonSearchField.keyboardAppearance = .default
            self.scrollView.backgroundColor = UIColor.white
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UserDefaults.standard.bool(forKey: "darkModeEnabled") ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.autocompleteTableView.delegate = self
        self.autocompleteTableView.dataSource = self
//        self.autocompleteTableView.layer.borderWidth = 1.5
//        self.autocompleteTableView.layer.borderColor = (UIColor.lightGray).cgColor
        self.autocompleteTableView.layer.cornerRadius = 10
        
        self.pokemonSearchField.delegate = self
        
        PokeApi.sharedInstance.getPokemonData(pokemonName: "bulbasaur", completionHandler: {(success, pokemon) in
            if (!success) {
                print("Error calling API")
            }
            else {
                if let pokemon = pokemon {
                    self.currentPokemon = pokemon
                    self.currentSpriteIndex = 0
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
        
        self.pokemonSearchField.endEditing(true)
        self.autocompleteTableView.isHidden = true

        if let pokemonToSearch = self.pokemonSearchField.text {
            print(pokemonToSearch)
                        
           // pokemonToSearch = pokemonToSearch.replacingOccurrences(of: " ", with: "-")
            PokeApi.sharedInstance.getPokemonData(pokemonName: pokemonToSearch, completionHandler: {(success, pokemon) in
                if (!success) {
                    print("Error calling API")
                }
                else {
                    if let pokemon = pokemon {
                        self.pokemonSearchField.text = ""
                        self.currentPokemon = pokemon
                        self.currentSpriteIndex = 0
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
                        self.pokemonSearchField.text = ""
                        failBanner.show()
                    }
                }
                
            })
        }
    }
    
    func downloadAndDisplaySprite(pokemonSpriteUrl: String) {
        var frontSpriteUrl: URL
        
        if pokemonSpriteUrl.isEmpty {
            frontSpriteUrl = URL(string: POKEMON_MISSING_SPRITE_URL)!
        }
        else {
            frontSpriteUrl = URL(string: pokemonSpriteUrl)!
        }
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
    
    @IBAction func userTypingPokemon(_ sender: Any) {
        // on each letter typed, search for the substring (from left to right, not just in middle,
        // and display to user the top 5 in alphabetical order
        var newTableHeight = 0
        
        if let partialString = self.pokemonSearchField?.text {
            self.autocompleteSuggestions = findPokemonSubString(partialString)
            
            print("number of suggestions: \(self.autocompleteSuggestions.count)")
            
            if self.autocompleteSuggestions.count > 5 {
                self.autocompleteSuggestions = Array(self.autocompleteSuggestions.prefix(upTo: 5))
            }
            else {
                self.autocompleteSuggestions = Array(self.autocompleteSuggestions.prefix(upTo: self.autocompleteSuggestions.count))
            }
            
            newTableHeight = 49 * (5 - self.autocompleteSuggestions.count)
            
            if self.autocompleteSuggestions.isEmpty || partialString.isEmpty {
                print("autocomplete suggestions is empty or partial string is empty")
                self.autocompleteTableView.isHidden = true
                self.autocompleteTableView.frame = CGRect(x: self.autocompleteTableView.frame.origin.x,
                                                          y: self.autocompleteTableView.frame.origin.y,
                                                          width: self.autocompleteTableView.frame.size.width,
                                                          height: 245.0)
            }
            else {
                self.autocompleteTableView.isHidden = false
                self.autocompleteTableView.frame = CGRect(x: self.autocompleteTableView.frame.origin.x,
                                                          y: self.autocompleteTableView.frame.origin.y,
                                                          width: self.autocompleteTableView.frame.size.width,
                                                          height: 245.0 - CGFloat(newTableHeight))
            }
            
            self.autocompleteTableView.reloadData()
        }
    }
    
    private func findPokemonSubString(_ partialText: String) -> [String] {
        // return an array of matched strings
        // return 5 of them
        let filteredPokemon = POKEMON_NAMES.filter({(item: String) -> Bool in
            let stringMatch = item.lowercased().hasPrefix(partialText.lowercased())
            return stringMatch
        })
        
        return filteredPokemon
    }
}
