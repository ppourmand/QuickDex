//
//  MatchupTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/20/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//
import UIKit
import CoreData
import QuartzCore

class MatchupCell: UITableViewCell {
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var typeOneLabel: UILabel!
    @IBOutlet weak var typeTwoLabel: UILabel!
    @IBOutlet weak var spriteView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
}

class MatchupTableViewController: UITableViewController {

    var pokemonOnTeam: [Pokemon] = []
    var searchedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.tableFooterView = UIView()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
        fetchRequest.predicate = NSPredicate(format: "uniqueId != nil")
        
        do {
            pokemonOnTeam = try managedContext.fetch(fetchRequest) as! [Pokemon]
            print(pokemonOnTeam.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
        fetchRequest.predicate = NSPredicate(format: "uniqueId != nil")

        do {
            pokemonOnTeam = try managedContext.fetch(fetchRequest) as! [Pokemon]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        // change the background color of the table itself based on mode
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            self.tableView.backgroundColor = UIColor.black
        }
        else {
            self.tableView.backgroundColor = UIColor.white
        }

        self.tableView.reloadData()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchupPokemonCell", for: indexPath) as! MatchupCell
        
        // check if we're in dark mode or light mode, and color background appropiately
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            cell.backgroundColor = UIColor.black
            cell.pokemonName.textColor = UIColor.white
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.pokemonName.textColor = UIColor.black
        }
        
        if indexPath.row >= pokemonOnTeam.count {
            cell.pokemonName?.text = " "
            cell.spriteView?.image = nil
            cell.typeOneLabel?.text = " "
            cell.typeTwoLabel?.text = " "
            cell.emptyLabel.isHidden = false
        }
        else {
            cell.emptyLabel.isHidden = true
            let pokemon = pokemonOnTeam[indexPath.row]
            cell.pokemonName.text = pokemon.name?.capitalized

            if let pokemonInDex = self.searchedPokemon {
                
                let effectivenessArray = pokemonInDex.typeEffectiveness?.allObjects as? [Type]
                if let typeOne = effectivenessArray!.filter({$0.name == pokemon.typeOne!}).first {
                    if typeOne.effectiveness >= 2.0 {
                        let typeOneAttributedString = self.createAttributedString(typeOne.name!, UIColor(red: 0.1804, green: 0.8, blue: 0.4431, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                    else if typeOne.effectiveness < 1.0 {
                        let typeOneAttributedString = self.createAttributedString(typeOne.name!, UIColor(red: 0.9059, green: 0.298, blue: 0.2353, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                    else {
                        let typeOneAttributedString = self.createAttributedString(typeOne.name!, UIColor(red: 0.7412, green: 0.7647, blue: 0.7804, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                }
                
                // if the team pokemon has a type two
                if pokemon.typeTwo != "\"\"" {
                    if let typeTwo = effectivenessArray!.filter({$0.name == pokemon.typeTwo!}).first {
                        if typeTwo.effectiveness >= 2.0 {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo.name!, UIColor(red: 0.1804, green: 0.8, blue: 0.4431, alpha: 1.0))
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                        else if typeTwo.effectiveness < 1.0 {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo.name!, UIColor(red: 0.9059, green: 0.298, blue: 0.2353, alpha: 1.0))
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                        else {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo.name!, UIColor(red: 0.7412, green: 0.7647, blue: 0.7804, alpha: 1.0))
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                    }
                }
                else {
                    cell.typeTwoLabel?.text = " "
                }
            }
            
            
            cell.spriteView.image = nil
            
            if let spritesArray = pokemon.sprites?.allObjects as? [SpriteUrl] {
                let frontDefaultSprite = spritesArray.filter({$0.direction == "frontDefault"}).first?.url
                
                var frontSpriteUrl: URL
                
                if frontDefaultSprite!.isEmpty {
                    frontSpriteUrl = URL(string: POKEMON_MISSING_SPRITE_URL)!
                }
                else {
                    frontSpriteUrl = URL(string: frontDefaultSprite!)!
                }
                URLSession.shared.dataTask(with: frontSpriteUrl as URL, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error ?? "No Error")
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let image = UIImage(data: data!)
                        cell.spriteView.image = image
                    })
                    
                }).resume()
            }
        }
        
        return cell
    }
    
    func createAttributedString(_ typeString: String, _ colorToSet: UIColor) -> NSAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: colorToSet]
        let attributedString = NSAttributedString(string: typeString.capitalized, attributes: firstAttributes)
        return attributedString
        
    }
}
