//
//  TypesTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/11/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class TypesTableViewController: UITableViewController {

    @IBOutlet weak var normalEffectivenessLabel: UILabel!
    @IBOutlet weak var fireEffectivenessLabel: UILabel!
    @IBOutlet weak var waterEffectivenessLabel: UILabel!
    @IBOutlet weak var fightingEffectivenessLabel: UILabel!
    @IBOutlet weak var grassEffectivenessLabel: UILabel!
    @IBOutlet weak var flyingEffectivenessLabel: UILabel!
    @IBOutlet weak var electricEffectivenessLabel: UILabel!
    @IBOutlet weak var poisonEffectivenessLabel: UILabel!
    @IBOutlet weak var psychicEffectivenessLabel: UILabel!
    @IBOutlet weak var groundEffectivenessLabel: UILabel!
    @IBOutlet weak var iceEffectivenessLabel: UILabel!
    @IBOutlet weak var rockEffectivenessLabel: UILabel!
    @IBOutlet weak var dragonEffectivenessLabel: UILabel!
    @IBOutlet weak var bugEffectivenessLabel: UILabel!
    @IBOutlet weak var darkEffectivenessLabel: UILabel!
    @IBOutlet weak var ghostEffectivenessLabel: UILabel!
    @IBOutlet weak var fairyEffectivenessLabel: UILabel!
    @IBOutlet weak var steelEffectivenessLabel: UILabel!
    @IBOutlet weak var unknownEffectivenessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setEffectivenessValues(normalEffectiveness: Double, fireEffectiveness: Double, waterEffectiveness: Double, fightingEffectiveness: Double, grassEffectiveness: Double, flyingEffectiveness: Double, electricEffectiveness: Double, poisonEffectiveness: Double, psychicEffectiveness: Double, groundEffectiveness: Double, iceEffectiveness: Double, rockEffectiveness: Double, dragonEffectiveness: Double, bugEffectiveness: Double, darkEffectiveness: Double, ghostEffectiveness: Double, fairyEffectiveness: Double, steelEffectiveness: Double) {
        
        self.normalEffectivenessLabel.text = "\(normalEffectiveness)x"
        self.fireEffectivenessLabel.text = "\(fireEffectiveness)x"
        self.waterEffectivenessLabel.text = "\(waterEffectiveness)x"
        self.fightingEffectivenessLabel.text = "\(fightingEffectiveness)x"
        self.grassEffectivenessLabel.text = "\(grassEffectiveness)x"
        self.flyingEffectivenessLabel.text = "\(flyingEffectiveness)x"
        self.electricEffectivenessLabel.text = "\(electricEffectiveness)x"
        self.poisonEffectivenessLabel.text = "\(poisonEffectiveness)x"
        self.psychicEffectivenessLabel.text = "\(psychicEffectiveness)x"
        self.groundEffectivenessLabel.text = "\(groundEffectiveness)x"
        self.iceEffectivenessLabel.text = "\(iceEffectiveness)x"
        self.rockEffectivenessLabel.text = "\(rockEffectiveness)x"
        self.dragonEffectivenessLabel.text = "\(dragonEffectiveness)x"
        self.bugEffectivenessLabel.text = "\(bugEffectiveness)x"
        self.darkEffectivenessLabel.text = "\(darkEffectiveness)x"
        self.ghostEffectivenessLabel.text = "\(ghostEffectiveness)x"
        self.fairyEffectivenessLabel.text = "\(fairyEffectiveness)x"
        self.steelEffectivenessLabel.text = "\(steelEffectiveness)x"
        
        self.setColor(normalEffectiveness, self.normalEffectivenessLabel)
        self.setColor(fireEffectiveness, self.fireEffectivenessLabel)
        self.setColor(waterEffectiveness, self.waterEffectivenessLabel)
        self.setColor(fightingEffectiveness, self.fightingEffectivenessLabel)
        self.setColor(grassEffectiveness, self.grassEffectivenessLabel)
        self.setColor(flyingEffectiveness, self.flyingEffectivenessLabel)
        self.setColor(electricEffectiveness, self.electricEffectivenessLabel)
        self.setColor(poisonEffectiveness, self.poisonEffectivenessLabel)
        self.setColor(psychicEffectiveness, self.psychicEffectivenessLabel)
        self.setColor(groundEffectiveness, self.groundEffectivenessLabel)
        self.setColor(groundEffectiveness, self.groundEffectivenessLabel)
        self.setColor(iceEffectiveness, self.iceEffectivenessLabel)
        self.setColor(rockEffectiveness, self.rockEffectivenessLabel)
        self.setColor(dragonEffectiveness, self.dragonEffectivenessLabel)
        self.setColor(bugEffectiveness, self.bugEffectivenessLabel)
        self.setColor(darkEffectiveness, self.darkEffectivenessLabel)
        self.setColor(ghostEffectiveness, self.ghostEffectivenessLabel)
        self.setColor(fairyEffectiveness, self.fairyEffectivenessLabel)
        self.setColor(steelEffectiveness, self.steelEffectivenessLabel)
    }
    
    func setColor(_ effectiveness: Double, _ labelToSet: UILabel){
        if effectiveness >= 2.0 {
            labelToSet.textColor = NOT_VERY_EFFECTIVE_COLOR
        }
        else if effectiveness < 1.0 {
            labelToSet.textColor = SUPER_EFFECTIVE_COLOR
        }
        else {
            labelToSet.textColor = NEUTRAL_EFFECTIVE_COLOR
        }
    }
}
