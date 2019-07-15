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
    var pokemonOnTeam: [NSManagedObject] = []
    var names: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamTableView.delegate = self
        self.teamTableView.dataSource = self
        self.teamTableView.tableFooterView = UIView()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PokemonTeamMember")

        do {
            pokemonOnTeam = try managedContext.fetch(fetchRequest)
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
                                            PokeApi.sharedInstance.getPokemonData(pokemonName: pokemonToSearch, completionHandler: {(success, pokemon) in
                                                if (!success) {
                                                    print("Error calling API in TeamViewController")
                                                }
                                                else {
                                                    if let pokemon = pokemon {
                                                        print(pokemon.uniqueID)
                                                        self.save(pokemonToSave: pokemon)
                                                        self.teamTableView.reloadData()
                                                    }
                                                    else {
                                                        let failBanner = StatusBarNotificationBanner(title: "Unable to find Pokemon", style: .danger)
                                                        failBanner.show()
                                                    }
                                                }
                                                
                                            })
                                        }
                                        else {
                                            self.present(failToAddAlert, animated: true)
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            alert.view.backgroundColor = UIColor.black
            alert.textFields?.first?.keyboardAppearance = .dark
        }
        
        present(alert, animated: true)
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
//        cell.pokemonName!.text = pokemonOnTeam[indexPath.row].name.capitalized
        cell.pokemonName?.text = (pokemon.value(forKey: "name") as? String)?.capitalized
        
        // displaying dex number
//        cell.pokemonDexNumber!.text = "National Dex: #\(pokemonOnTeam[indexPath.row].number)"
        cell.pokemonDexNumber?.text = "National Dex #" + ((pokemon.value(forKey: "numberId") as? String)!)
        
        // displaying types
        if let typeOne = pokemon.value(forKey: "typeOne") as? String {
            cell.pokemonTypeOne?.text = typeOne.capitalized
        }
        if let typeTwo = pokemon.value(forKey: "typeTwo") as? String {
            cell.pokemonTypeTwo?.text = typeTwo.capitalized
        }
        
        cell.pokemonSprite.image = nil
        
        // grabbing the front sprite
        if let frontSpriteString = pokemon.value(forKey: "spriteUrl") as? String {
            let frontSpriteUrl = URL(string: frontSpriteString)!
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
    
    // save the value into core data
    func save(pokemonToSave: Pokemon) {
        print("attempting to save")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "PokemonTeamMember",
                                       in: managedContext)!
        
        let poke = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        
        if pokemonToSave.types.count == 2 {
            poke.setValue(pokemonToSave.name, forKeyPath: "name")
            poke.setValue(pokemonToSave.number, forKey: "numberId")
            poke.setValue(pokemonToSave.types[0].name, forKey: "typeOne")
            poke.setValue(pokemonToSave.types[1].name, forKey: "typeTwo")
            poke.setValue(pokemonToSave.sprites.frontDefault, forKey: "spriteUrl")
            poke.setValue(pokemonToSave.uniqueID, forKey: "uniqueId")
        }
        else {
            poke.setValue(pokemonToSave.name, forKeyPath: "name")
            poke.setValue(pokemonToSave.number, forKey: "numberId")
            poke.setValue(pokemonToSave.types[0].name, forKey: "typeOne")
            poke.setValue(" ", forKey: "typeTwo")
            poke.setValue(pokemonToSave.sprites.frontDefault, forKey: "spriteUrl")
            poke.setValue(pokemonToSave.uniqueID, forKey: "uniqueId")
        }
        
        // 4
        do {
            try managedContext.save()
            pokemonOnTeam.append(poke)
            print("Appended pokemon and saved!!")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // delete pokemon from core data
    func delete(_ pokemonToDelete: NSManagedObject) {
        print("attempting to delete")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonTeamMember")
//        fetchRequest.predicate = NSPredicate(format: "uniqueId= %@", idToDelete as CVarArg)
        
        do {
//            let poke = try managedContext.fetch(fetchRequest)
            
//            let pokeToDelete = poke[0] as! NSManagedObject
            managedContext.delete(pokemonToDelete)
            print("successfully deleted!")
            
            do {
                try managedContext.save()
                print("sucessfully saved the delete action")
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
