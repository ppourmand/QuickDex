//
//  PokedexViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit
import NotificationBanner
import CoreData

class AutocompleteCell: UITableViewCell {
    @IBOutlet weak var pokemonNameLabel: UILabel!
}

class PokedexViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    // ------------------------------------------------------------------------------------------------------------------------
    // Table View related logic for the autocomplete popup/tableview
    // ------------------------------------------------------------------------------------------------------------------------
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

    
    // ------------------------------------------------------------
    // This function used to change sprites based on taps
    // but this was removed because I wanted to submit to app store
    // as soon as I could
    // ------------------------------------------------------------
    @IBAction func tappedSprite(_ sender: Any) {
        print("tapped on sprite")
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
            self.pokemonSearchField.attributedPlaceholder = NSAttributedString(string: "Pokemon Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            self.pokemonSpriteImageView.backgroundColor = UIColor.black
            self.pokemonSearchField.keyboardAppearance = .dark
            self.navigationBar.barTintColor = DARK_MODE_BAR_COLOR
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.view.backgroundColor = DARK_MODE_BAR_COLOR
            self.scrollView.backgroundColor = UIColor.black
            self.autocompleteTableView.backgroundColor = UIColor.black

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
            self.pokemonSearchField.attributedPlaceholder = NSAttributedString(string: "Pokemon Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.pokemonSpriteImageView.backgroundColor = UIColor.white
            self.pokemonSearchField.keyboardAppearance = .default
            self.scrollView.backgroundColor = UIColor.white
            self.autocompleteTableView.backgroundColor = UIColor.white
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
        self.autocompleteTableView.layer.cornerRadius = 10
        
        self.pokemonSearchField.delegate = self
        
        PokeApi.sharedInstance.getPokemonData(pokemonName: "bulbasaur", completionHandler: {(success, convertedPokemonName) in
            if (!success) {
                print("Error calling API")
            }
            else {
                // coredata context getting
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                var pokemon: Pokemon?
                
                // fetch the pokemon data (in this case, always bulbasaur on viewdidload)
                do {
                    let pokemonFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                    pokemonFetchRequest.predicate = NSPredicate(format: "name == %@", convertedPokemonName)
                    let results = try managedContext.fetch(pokemonFetchRequest) as! [Pokemon]
                    pokemon = results[0]
                    
                } catch let error as NSError {
                    print("Error: \(error), \(error.userInfo)")
                }
                
                self.currentPokemon = pokemon
                
                // send the pokemon that we searched to the matchup view controller and reload the data
                self.matchupViewController?.searchedPokemon = pokemon
                self.matchupViewController?.tableView.reloadData()
                
                var prettyPokemonName = pokemon?.name!.replacingOccurrences(of: "-", with: " ")
                prettyPokemonName = prettyPokemonName?.capitalized
                self.pokemonNameLabel.text = prettyPokemonName
                self.pokemonDexNumberLabel.text = "National Dex: #\(pokemon?.numberId ?? "")"

                // set the type labels, if it only has 1 type, the other should not be set
                if pokemon?.typeOne != "" {
                    self.pokemonTypeOneLabel.text = pokemon?.typeOne?.capitalized
                }
                if pokemon?.typeTwo != "" {
                    self.pokemonTypeTwoLabel.text = pokemon?.typeTwo?.capitalized
                }
                

                if let statsArray = pokemon?.stats?.allObjects as? [Stat] {
                    var attackStat = ""
                    var healthStat = ""
                    var defenseStat = ""
                    var specialAttackStat = ""
                    var specialDefenseStat = ""
                    var speedStat = ""
                    
                    for stat in statsArray {
                        if stat.name == "attack" {
                            attackStat = stat.baseStat!
                        }
                        if stat.name == "defense" {
                            defenseStat = stat.baseStat!
                        }
                        if stat.name == "hp" {
                            healthStat = stat.baseStat!
                        }
                        if stat.name == "special-attack" {
                            specialAttackStat = stat.baseStat!
                        }
                        if stat.name == "special-defense" {
                            specialDefenseStat = stat.baseStat!
                        }
                        if stat.name == "speed" {
                            speedStat = stat.baseStat!
                        }
                    }
                    
                    self.statViewController?.setStats(attackStat: attackStat, healthStat: healthStat, defenseStat: defenseStat, specialAttackStat: specialAttackStat, specialDefenseStat: specialDefenseStat, speedStat: speedStat)
                }
                
                if let effectivenessArray = pokemon?.typeEffectiveness?.allObjects as? [Type] {
                    let normal = effectivenessArray.filter({$0.name == "normal"}).first
                    let fire = effectivenessArray.filter({$0.name == "fire"}).first
                    let water = effectivenessArray.filter({$0.name == "water"}).first
                    let fighting = effectivenessArray.filter({$0.name == "fighting"}).first
                    let grass = effectivenessArray.filter({$0.name == "grass"}).first
                    let flying = effectivenessArray.filter({$0.name == "flying"}).first
                    let electric = effectivenessArray.filter({$0.name == "electric"}).first
                    let poison = effectivenessArray.filter({$0.name == "poison"}).first
                    let psychic = effectivenessArray.filter({$0.name == "psychic"}).first
                    let ground = effectivenessArray.filter({$0.name == "ground"}).first
                    let ice = effectivenessArray.filter({$0.name == "ice"}).first
                    let rock = effectivenessArray.filter({$0.name == "rock"}).first
                    let dragon = effectivenessArray.filter({$0.name == "dragon"}).first
                    let bug = effectivenessArray.filter({$0.name == "bug"}).first
                    let dark = effectivenessArray.filter({$0.name == "dark"}).first
                    let ghost = effectivenessArray.filter({$0.name == "ghost"}).first
                    let fairy = effectivenessArray.filter({$0.name == "fairy"}).first
                    let steel = effectivenessArray.filter({$0.name == "steel"}).first
                    
                    self.typeEffectivenessViewController?.setEffectivenessValues(normalEffectiveness: normal!.effectiveness, fireEffectiveness: fire!.effectiveness, waterEffectiveness: water!.effectiveness, fightingEffectiveness: fighting!.effectiveness, grassEffectiveness: grass!.effectiveness, flyingEffectiveness: flying!.effectiveness, electricEffectiveness: electric!.effectiveness, poisonEffectiveness: poison!.effectiveness, psychicEffectiveness: psychic!.effectiveness, groundEffectiveness: ground!.effectiveness, iceEffectiveness: ice!.effectiveness, rockEffectiveness: rock!.effectiveness, dragonEffectiveness: dragon!.effectiveness, bugEffectiveness: bug!.effectiveness, darkEffectiveness: dark!.effectiveness, ghostEffectiveness: ghost!.effectiveness, fairyEffectiveness: fairy!.effectiveness, steelEffectiveness: steel!.effectiveness)
                }
                
                if let spritesArray = pokemon?.sprites?.allObjects as? [SpriteUrl] {
                    let frontDefaultSprite = spritesArray.filter({$0.direction == "frontDefault"}).first?.url
                    self.downloadAndDisplaySprite(pokemonSpriteUrl: frontDefaultSprite!)
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
            PokeApi.sharedInstance.getPokemonData(pokemonName: pokemonToSearch, completionHandler: {(success, convertedPokemonName) in
                if (!success) {
                    print("Error calling API")
                }
                else {
                    // coredata context getting
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    var pokemon: Pokemon?
                    
                    // fetch the pokemon data
                    do {
                        let pokemonFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                        pokemonFetchRequest.predicate = NSPredicate(format: "name == %@", convertedPokemonName)
                        print("converted pokemon: \(convertedPokemonName)")
                        let results = try managedContext.fetch(pokemonFetchRequest) as! [Pokemon]
                        pokemon = results[0]
                        
                    } catch let error as NSError {
                        print("Error: \(error), \(error.userInfo)")
                    }
                    
                    // send the pokemon that we searched to the matchup view controller and reload the data
                    self.matchupViewController?.searchedPokemon = pokemon
                    self.matchupViewController?.tableView.reloadData()
                    
                    self.currentPokemon = pokemon
                    var prettyPokemonName = pokemon?.name!.replacingOccurrences(of: "-", with: " ")
                    prettyPokemonName = prettyPokemonName?.capitalized
                    self.pokemonSearchField.text = ""
                    self.pokemonNameLabel.text = prettyPokemonName
                    self.pokemonDexNumberLabel.text = "National Dex: #\(pokemon?.numberId ?? "")"
                    

                    if pokemon?.typeOne != "\"\"" {
                        self.pokemonTypeOneLabel.text = pokemon?.typeOne?.capitalized
                    }
                    
                    // for some reason if it doesn't have a second type it literally has the quotation characters instead of empty strings
                    // TODO: fix that
                    if pokemon?.typeTwo != "\"\"" {
                        self.pokemonTypeTwoLabel.text = pokemon?.typeTwo?.capitalized
                    }
                    else {
                        self.pokemonTypeTwoLabel.text = " "
                    }
                    
                    if let statsArray = pokemon?.stats?.allObjects as? [Stat] {
                        var attackStat = ""
                        var healthStat = ""
                        var defenseStat = ""
                        var specialAttackStat = ""
                        var specialDefenseStat = ""
                        var speedStat = ""
                        
                        for stat in statsArray {
                            if stat.name == "attack" {
                                attackStat = stat.baseStat!
                            }
                            if stat.name == "defense" {
                                defenseStat = stat.baseStat!
                            }
                            if stat.name == "hp" {
                                healthStat = stat.baseStat!
                            }
                            if stat.name == "special-attack" {
                                specialAttackStat = stat.baseStat!
                            }
                            if stat.name == "special-defense" {
                                specialDefenseStat = stat.baseStat!
                            }
                            if stat.name == "speed" {
                                speedStat = stat.baseStat!
                            }
                        }
                        
                        self.statViewController?.setStats(attackStat: attackStat, healthStat: healthStat, defenseStat: defenseStat, specialAttackStat: specialAttackStat, specialDefenseStat: specialDefenseStat, speedStat: speedStat)
                        
                    }
                    
                    if let effectivenessArray = pokemon?.typeEffectiveness?.allObjects as? [Type] {
                        let normal = effectivenessArray.filter({$0.name == "normal"}).first
                        let fire = effectivenessArray.filter({$0.name == "fire"}).first
                        let water = effectivenessArray.filter({$0.name == "water"}).first
                        let fighting = effectivenessArray.filter({$0.name == "fighting"}).first
                        let grass = effectivenessArray.filter({$0.name == "grass"}).first
                        let flying = effectivenessArray.filter({$0.name == "flying"}).first
                        let electric = effectivenessArray.filter({$0.name == "electric"}).first
                        let poison = effectivenessArray.filter({$0.name == "poison"}).first
                        let psychic = effectivenessArray.filter({$0.name == "psychic"}).first
                        let ground = effectivenessArray.filter({$0.name == "ground"}).first
                        let ice = effectivenessArray.filter({$0.name == "ice"}).first
                        let rock = effectivenessArray.filter({$0.name == "rock"}).first
                        let dragon = effectivenessArray.filter({$0.name == "dragon"}).first
                        let bug = effectivenessArray.filter({$0.name == "bug"}).first
                        let dark = effectivenessArray.filter({$0.name == "dark"}).first
                        let ghost = effectivenessArray.filter({$0.name == "ghost"}).first
                        let fairy = effectivenessArray.filter({$0.name == "fairy"}).first
                        let steel = effectivenessArray.filter({$0.name == "steel"}).first
                        
                        self.typeEffectivenessViewController?.setEffectivenessValues(normalEffectiveness: normal!.effectiveness, fireEffectiveness: fire!.effectiveness, waterEffectiveness: water!.effectiveness, fightingEffectiveness: fighting!.effectiveness, grassEffectiveness: grass!.effectiveness, flyingEffectiveness: flying!.effectiveness, electricEffectiveness: electric!.effectiveness, poisonEffectiveness: poison!.effectiveness, psychicEffectiveness: psychic!.effectiveness, groundEffectiveness: ground!.effectiveness, iceEffectiveness: ice!.effectiveness, rockEffectiveness: rock!.effectiveness, dragonEffectiveness: dragon!.effectiveness, bugEffectiveness: bug!.effectiveness, darkEffectiveness: dark!.effectiveness, ghostEffectiveness: ghost!.effectiveness, fairyEffectiveness: fairy!.effectiveness, steelEffectiveness: steel!.effectiveness)
                    }

                    if let spritesArray = pokemon?.sprites?.allObjects as? [SpriteUrl] {
                        let frontDefaultSprite = spritesArray.filter({$0.direction == "frontDefault"}).first?.url
                        self.downloadAndDisplaySprite(pokemonSpriteUrl: frontDefaultSprite!)
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
                        
            if self.autocompleteSuggestions.count > 5 {
                self.autocompleteSuggestions = Array(self.autocompleteSuggestions.prefix(upTo: 5))
            }
            else {
                self.autocompleteSuggestions = Array(self.autocompleteSuggestions.prefix(upTo: self.autocompleteSuggestions.count))
            }
            
            newTableHeight = 49 * (5 - self.autocompleteSuggestions.count)
            
            if self.autocompleteSuggestions.isEmpty || partialString.isEmpty {
                //print("autocomplete suggestions is empty or partial string is empty")
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
    

}

public func findPokemonSubString(_ partialText: String) -> [String] {
    // return an array of matched strings
    // return 5 of them
    let filteredPokemon = POKEMON_NAMES.filter({(item: String) -> Bool in
        let stringMatch = item.lowercased().hasPrefix(partialText.lowercased())
        return stringMatch
    })
    
    return filteredPokemon
}
