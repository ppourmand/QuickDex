//
//  MatchupTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/20/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit
import CoreData

class MatchupCell: UITableViewCell {
    @IBOutlet weak var pokemonName: UILabel!
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
        
        if pokemonOnTeam.isEmpty {
            self.tableView.isHidden = true
        }
        else {
            self.tableView.isHidden = false
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
        
        if pokemonOnTeam.isEmpty {
            self.tableView.isHidden = true
        }
        else {
            self.tableView.isHidden = false
        }
        
        self.tableView.reloadData()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(pokemonOnTeam.count)
        return pokemonOnTeam.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchupPokemonCell", for: indexPath) as! MatchupCell
        let pokemon = pokemonOnTeam[indexPath.row]
        cell.pokemonName?.text = (pokemon.value(forKey: "name") as? String)?.capitalized
        
        if let pokemonInDex = self.searchedPokemon {
//            print(pokemonInDex.typeEffectiveness)
            var totalEffectiveness: Double = 0.0

            if let typeOne = pokemon.value(forKey: "typeOne") as? String {
                print("type one of team poke: \(typeOne)")
//                print(pokemonInDex.typeEffectiveness)
                totalEffectiveness += self.isSuperEffectiveAgainst(pokemonInDex, typeOne)

            }
            if let typeTwo = pokemon.value(forKey: "typeTwo") as? String {
                print("type two of team poke: \(typeTwo)")

                if typeTwo != " " {
                    totalEffectiveness += self.isSuperEffectiveAgainst(pokemonInDex, typeTwo)
                }
            }

            print("dex poke: \(pokemonInDex.name) team poke: \(pokemon.value(forKey: "name"))")
            print("totalEffectiveness: \(totalEffectiveness)")
            
            if totalEffectiveness >= 2 {
                cell.backgroundColor = UIColor(hue: 0.3278, saturation: 1, brightness: 0.95, alpha: 1.0) /* #08f200 */
            }
            else if totalEffectiveness > 1 && totalEffectiveness < 2 {
                cell.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1.0) /* #ffcc00 */
            }
            else if totalEffectiveness < 0 {
                cell.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1.0) /* #ff0000 */
            }

        }
        
//        cell.backgroundColor = UIColor(hue: 0.3278, saturation: 1, brightness: 0.95, alpha: 1.0) /* #08f200 */
        return cell
    }
 
    func isSuperEffectiveAgainst(_ pokemonInDex: Pokemon, _ pokemonOnTeamType: String) -> Double {
        if pokemonInDex.typeEffectiveness[pokemonOnTeamType]! < 1 {
            return -pokemonInDex.typeEffectiveness[pokemonOnTeamType]!
        }
        else if pokemonInDex.typeEffectiveness[pokemonOnTeamType]! == 1{
            return 0
        }
        else {
            return pokemonInDex.typeEffectiveness[pokemonOnTeamType]!
        }
//
//        if pokemonInDex.typeEffectiveness[pokemonOnTeamType]! > 1.0 {
//            print("value of type: \(pokemonOnTeamType) value: \(pokemonInDex.typeEffectiveness[pokemonOnTeamType]!)")
//            return 1
//        }
//        else {
//            print("value of type: \(pokemonOnTeamType) value: \(pokemonInDex.typeEffectiveness[pokemonOnTeamType]!)")
//            return -1
//        }
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
