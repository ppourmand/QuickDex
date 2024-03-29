//
//  TeamViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/17/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import CoreData
import UIKit
import NotificationBanner

let MAX_POKEMON = 6

class PokemonCell: UITableViewCell {
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonSprite: UIImageView!
    @IBOutlet weak var pokemonDexNumber: UILabel!
    @IBOutlet weak var pokemonTypeOne: UILabel!
    @IBOutlet weak var pokemonTypeTwo: UILabel!
}

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var pokemonOnTeam: [Pokemon] = []
    var names: [String] = []
    var lettersTypedSoFar: String = ""
    var oldCursorPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamTableView.delegate = self
        self.teamTableView.dataSource = self
        self.teamTableView.tableFooterView = UIView()

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled"){
            self.teamTableView.backgroundColor = UIColor.black
            self.navigationBar.barTintColor = DARK_MODE_BAR_COLOR
            self.navigationBar.isTranslucent = false
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

            self.view.backgroundColor = DARK_MODE_BAR_COLOR
        }
        else {
            self.teamTableView.backgroundColor = UIColor.white
            self.navigationBar.barTintColor = UIColor.white
            self.view.backgroundColor = UIColor.white
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]


        }
        setNeedsStatusBarAppearanceUpdate()
        self.teamTableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UserDefaults.standard.bool(forKey: "darkModeEnabled") ? .lightContent : .default
    }
    
    @IBAction func addPokemonToTeam(_ sender: Any) {
        self.oldCursorPosition = 0
        
        let alert = UIAlertController(title: "New Pokemon",
                                      message: "Add a new Pokemon to the team",
                                      preferredStyle: .alert)
        
        let failToAddAlert = UIAlertController(title: "Team Full",
                                               message: "Please delete a pokemon from your team before adding a new one",
                                               preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: .cancel)
        
        failToAddAlert.addAction(okAction)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                                                                
                                        if self.pokemonOnTeam.count < MAX_POKEMON {
                                            let pokemonToSearch = nameToSave.replacingOccurrences(of: " ", with: "-")
                                            PokeApi.sharedInstance.getPokemonData(pokemonName: pokemonToSearch, uniqueID: UUID(), completionHandler: {(success, convertedPokemonName) in
                                                if (!success) {
                                                    print("Error calling API in TeamViewController")
                                                }
                                                else {
                                                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                                                    let managedContext = appDelegate.persistentContainer.viewContext
                                                    let pokemonFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
                                                    pokemonFetchRequest.predicate = NSPredicate(format: "uniqueId != nil")
                                                    
                                                    // 4
                                                    do {
                                                        let result = try managedContext.fetch(pokemonFetchRequest) as! [Pokemon]
                                                        self.pokemonOnTeam = result
                                                    } catch let error as NSError {
                                                        print("Could not save. \(error), \(error.userInfo)")
                                                    }

                                                    self.teamTableView.reloadData()
                                                }

                                            })
                                        }
                                        else {
                                            self.present(failToAddAlert, animated: true)
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.placeholder = "Pokemon Name"
            textField.addTarget(self, action: #selector(TeamViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            alert.view.backgroundColor = UIColor.black
            alert.textFields?.first?.keyboardAppearance = .dark
        }
        
        present(alert, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var autocompleteSuggestions: [String] = []

        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.end)
            oldCursorPosition = cursorPosition - oldCursorPosition

            if let partialString = textField.text {
                if !partialString.isEmpty{
                    self.lettersTypedSoFar = String(partialString[..<partialString.index(partialString.startIndex, offsetBy: cursorPosition)])
                    autocompleteSuggestions = findPokemonSubString(self.lettersTypedSoFar)
                }
            }
            
            if let suggestedText = autocompleteSuggestions.first {
                let typedText = NSMutableAttributedString(string: self.lettersTypedSoFar)
                let greyedOutSuggestedText = NSMutableAttributedString(string: String(suggestedText.suffix(suggestedText.count - self.lettersTypedSoFar.count)), attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                
                typedText.append(greyedOutSuggestedText)
                textField.attributedText = typedText
            }
            else {
                textField.text = self.lettersTypedSoFar
            }
            
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            
            if lettersTypedSoFar.isEmpty {
                textField.text = ""
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonOnTeam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell") as! PokemonCell
        let pokemon = pokemonOnTeam[indexPath.row]
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            cell.backgroundColor = UIColor.black
            cell.pokemonName?.textColor = UIColor.white
            cell.pokemonDexNumber?.textColor = UIColor.white
            cell.pokemonTypeOne?.textColor = UIColor.white
            cell.pokemonTypeTwo?.textColor = UIColor.white
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.pokemonName?.textColor = UIColor.black
            cell.pokemonDexNumber?.textColor = UIColor.black
            cell.pokemonTypeOne?.textColor = UIColor.black
            cell.pokemonTypeTwo?.textColor = UIColor.black
        }
        
        // displaying name
        cell.pokemonName.text = pokemon.name?.capitalized
        
        // displaying dex number
        cell.pokemonDexNumber.text = "National Dex #" + pokemon.numberId!
        
        // displaying types
        cell.pokemonTypeOne?.text = pokemon.typeOne?.capitalized
        if pokemon.typeTwo != "\"\"" {
            cell.pokemonTypeTwo?.text = pokemon.typeTwo?.capitalized
        }
        else {
            cell.pokemonTypeTwo?.text = " "
        }

        
        cell.pokemonSprite.image = nil
        
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
                    cell.pokemonSprite.image = image
                })
                
            }).resume()
            
        }
        
        return cell
    }

    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let pokemon = pokemonOnTeam[indexPath.row]
            
            // remove the item from the data model
            pokemonOnTeam.remove(at: indexPath.row)

            self.delete(pokemon)
            teamTableView.deleteRows(at: [indexPath], with: .fade)
            
            if pokemonOnTeam.isEmpty {
                self.teamTableView.backgroundView = nil
            }

        }
    }

    // delete pokemon from core data
    func delete(_ pokemonToDelete: Pokemon) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        fetchRequest.predicate = NSPredicate(format: "uniqueId == %@", pokemonToDelete.uniqueId! as CVarArg)

        do {
            let matchedPokemon = try managedContext.fetch(fetchRequest) as! [Pokemon]

            let pokeToDelete = matchedPokemon.first
            managedContext.delete(pokeToDelete!)
            print("Successfully deleted pokemon: \(pokemonToDelete.name!)")

            do {
                try managedContext.save()
                print("Sucessfully saved the delete action")
            }
            catch {
                print("Unable to save during a delete in core data: \(error)")
            }
        }
        catch {
            print("Unable to delete: \(error)")
        }
    }

}
