//
//  PokemonStatsTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class PokemonStatsTableViewController: UITableViewController {
    @IBOutlet weak var attackStatBar: UIProgressView!
    @IBOutlet weak var specialAttackStatBar: UIProgressView!
    @IBOutlet weak var defenseStatBar: UIProgressView!
    @IBOutlet weak var specialDefenseStatBar: UIProgressView!
    @IBOutlet weak var speedStatBar: UIProgressView!
    @IBOutlet weak var healthStatBar: UIProgressView!
    
    var healthStat: String = ""
    var attackStat: String = ""
    var defenseStat: String = ""
    var specialAttackStat: String = ""
    var specialDefenseStat: String = ""
    var speedStat: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func setStats(attackStat: String, healthStat: String, defenseStat: String, specialAttackStat: String,
                  specialDefenseStat: String, speedStat: String) {
        self.healthStatBar.setProgress((Float(healthStat)! / 200.0), animated: true)
        self.attackStatBar.setProgress((Float(attackStat)! / 200.0), animated: true)
        self.defenseStatBar.setProgress((Float(defenseStat)! / 200.0), animated: true)
        self.specialAttackStatBar.setProgress((Float(specialAttackStat)! / 200.0), animated: true)
        self.specialDefenseStatBar.setProgress((Float(specialDefenseStat)! / 200.0), animated: true)
        self.speedStatBar.setProgress((Float(speedStat)! / 200.0), animated: true)
    }
}
