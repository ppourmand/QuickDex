//
//  PokemonStatsTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/7/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class PokemonStatsTableViewController: UITableViewController {
    
    // progress bars per cell
    @IBOutlet weak var attackStatBar: UIProgressView!
    @IBOutlet weak var specialAttackStatBar: UIProgressView!
    @IBOutlet weak var defenseStatBar: UIProgressView!
    @IBOutlet weak var specialDefenseStatBar: UIProgressView!
    @IBOutlet weak var speedStatBar: UIProgressView!
    @IBOutlet weak var healthStatBar: UIProgressView!
    
    // all the cells
    @IBOutlet weak var hpCell: UITableViewCell!
    @IBOutlet weak var attackCell: UITableViewCell!
    @IBOutlet weak var defenseCell: UITableViewCell!
    @IBOutlet weak var specialAttackCell: UITableViewCell!
    @IBOutlet weak var specialDefenseCell: UITableViewCell!
    @IBOutlet weak var speedCell: UITableViewCell!
    
    // all the labels
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    var healthStat: String = ""
    var attackStat: String = ""
    var defenseStat: String = ""
    var specialAttackStat: String = ""
    var specialDefenseStat: String = ""
    var speedStat: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            print("enable dark mode")
            self.tableView.backgroundColor = UIColor.black
            self.hpCell.backgroundColor = UIColor.black
            self.attackCell.backgroundColor = UIColor.black
            self.defenseCell.backgroundColor = UIColor.black
            self.specialAttackCell.backgroundColor = UIColor.black
            self.specialDefenseCell.backgroundColor = UIColor.black
            self.speedCell.backgroundColor = UIColor.black
            self.hpLabel.textColor = UIColor.white
            self.attackLabel.textColor = UIColor.white
            self.defenseLabel.textColor = UIColor.white
            self.specialAttackLabel.textColor = UIColor.white
            self.specialDefenseLabel.textColor = UIColor.white
            self.speedLabel.textColor = UIColor.white
        }
        else {
            print("enable light mode")
            self.tableView.backgroundColor = UIColor.white
            self.hpCell.backgroundColor = UIColor.white
            self.attackCell.backgroundColor = UIColor.white
            self.defenseCell.backgroundColor = UIColor.white
            self.specialAttackCell.backgroundColor = UIColor.white
            self.specialDefenseCell.backgroundColor = UIColor.white
            self.speedCell.backgroundColor = UIColor.white
            self.hpLabel.textColor = UIColor.black
            self.attackLabel.textColor = UIColor.black
            self.defenseLabel.textColor = UIColor.black
            self.specialAttackLabel.textColor = UIColor.black
            self.specialDefenseLabel.textColor = UIColor.black
            self.speedLabel.textColor = UIColor.black
        }
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
