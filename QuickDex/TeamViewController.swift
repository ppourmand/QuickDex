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
    var pokemonOnTeam: [NSManagedObject] = []
    var names: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.teamTableView.delegate = self
        self.teamTableView.dataSource = self
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PokemonTeamMember")
        
        //3
        do {
            pokemonOnTeam = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        
        // displaying name
//        cell.pokemonName!.text = pokemonOnTeam[indexPath.row].name.capitalized
        cell.pokemonName?.text = (pokemon.value(forKey: "name") as? String)?.capitalized
        
        // displaying dex number
//        cell.pokemonDexNumber!.text = "National Dex: #\(pokemonOnTeam[indexPath.row].number)"
        cell.pokemonDexNumber?.text = (pokemon.value(forKey: "numberId") as? String)
        
        // displaying types
        if let typeOne = pokemon.value(forKey: "typeOne") as? String {
            cell.pokemonTypeOne?.text = typeOne
        }
        if let typeTwo = pokemon.value(forKey: "typeTwo") as? String {
            cell.pokemonTypeTwo?.text = typeTwo
        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let pokemon = pokemonOnTeam[indexPath.row]
            
            // remove the item from the data model
            pokemonOnTeam.remove(at: indexPath.row)

            self.delete((pokemon.value(forKey: "uniqueId") as? UUID)!)
            teamTableView.deleteRows(at: [indexPath], with: .fade)

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
    func delete(_ idToDelete: UUID) {
        print("attempting to delete")
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokemonTeamMember")
        fetchRequest.predicate = NSPredicate(format: "uniqueId= %@", idToDelete as CVarArg)
        
        do {
            let poke = try managedContext.fetch(fetchRequest)
            
            let pokeToDelete = poke[0] as! NSManagedObject
            managedContext.delete(pokeToDelete)
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
