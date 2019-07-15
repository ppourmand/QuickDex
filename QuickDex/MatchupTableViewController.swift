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

    var pokemonOnTeam: [NSManagedObject] = []
    var searchedPokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        // no extra bs cells
        self.tableView.tableFooterView = UIView()

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
        //return pokemonOnTeam.count
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
            cell.pokemonName?.text = (pokemon.value(forKey: "name") as? String)?.capitalized
            
            if let pokemonInDex = self.searchedPokemon {
                
                if let typeOne = pokemon.value(forKey: "typeOne") as? String {
                    if pokemonInDex.typeEffectiveness[typeOne]! >= 2.0 {
                        let typeOneAttributedString = self.createAttributedString(typeOne, UIColor(red: 0.1804, green: 0.8, blue: 0.4431, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                    else if pokemonInDex.typeEffectiveness[typeOne]! < 1.0 {
                        let typeOneAttributedString = self.createAttributedString(typeOne, UIColor(red: 0.9059, green: 0.298, blue: 0.2353, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                    else {
                        let typeOneAttributedString = self.createAttributedString(typeOne, UIColor(red: 0.7412, green: 0.7647, blue: 0.7804, alpha: 1.0))
                        cell.typeOneLabel?.attributedText = typeOneAttributedString
                    }
                }
                if let typeTwo = pokemon.value(forKey: "typeTwo") as? String {
                    if typeTwo != " "{
                        if pokemonInDex.typeEffectiveness[typeTwo]! >= 2.0 {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo, SUPER_EFFECTIVE_COLOR)
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                        else if pokemonInDex.typeEffectiveness[typeTwo]! < 1.0 {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo, NOT_VERY_EFFECTIVE_COLOR)
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                        else {
                            let typeTwoAttributedString = self.createAttributedString(typeTwo, NEUTRAL_EFFECTIVE_COLOR)
                            cell.typeTwoLabel?.attributedText = typeTwoAttributedString
                        }
                    }
                    else {
                        cell.typeTwoLabel?.text =  " "
                    }
                }
            }
            
            cell.spriteView.image = nil
            
            if let frontSpriteString = pokemon.value(forKey: "spriteUrl") as? String {
                let frontSpriteUrl = URL(string: frontSpriteString)!
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
    
    func createAttributedString(_ typeString: String, _ colorToSet: UIColor) -> NSAttributedString{
        
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: colorToSet]
        
        let attributedString = NSAttributedString(string: typeString.capitalized, attributes: firstAttributes)
        
        return attributedString
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
