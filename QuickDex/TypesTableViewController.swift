//
//  TypesTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/11/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class TypesTableViewController: UITableViewController {

    // effectiveness labels
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
    
    // type cells
    @IBOutlet weak var normalCell: UITableViewCell!
    @IBOutlet weak var fireCell: UITableViewCell!
    @IBOutlet weak var waterCell: UITableViewCell!
    @IBOutlet weak var fightingCell: UITableViewCell!
    @IBOutlet weak var grassCell: UITableViewCell!
    @IBOutlet weak var flyingCell: UITableViewCell!
    @IBOutlet weak var electricCell: UITableViewCell!
    @IBOutlet weak var poisonCell: UITableViewCell!
    @IBOutlet weak var psychicCell: UITableViewCell!
    @IBOutlet weak var groundCell: UITableViewCell!
    @IBOutlet weak var iceCell: UITableViewCell!
    @IBOutlet weak var rockCell: UITableViewCell!
    @IBOutlet weak var dragonCell: UITableViewCell!
    @IBOutlet weak var bugCell: UITableViewCell!
    @IBOutlet weak var darkCell: UITableViewCell!
    @IBOutlet weak var ghostCell: UITableViewCell!
    @IBOutlet weak var fairyCell: UITableViewCell!
    @IBOutlet weak var steelCell: UITableViewCell!
    @IBOutlet weak var unknownCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            self.tableView.backgroundColor = UIColor.black
            self.normalCell.backgroundColor = UIColor.black
            self.fireCell.backgroundColor = UIColor.black
            self.waterCell.backgroundColor = UIColor.black
            self.fightingCell.backgroundColor = UIColor.black
            self.grassCell.backgroundColor = UIColor.black
            self.flyingCell.backgroundColor = UIColor.black
            self.electricCell.backgroundColor = UIColor.black
            self.poisonCell.backgroundColor = UIColor.black
            self.psychicCell.backgroundColor = UIColor.black
            self.groundCell.backgroundColor = UIColor.black
            self.iceCell.backgroundColor = UIColor.black
            self.rockCell.backgroundColor = UIColor.black
            self.dragonCell.backgroundColor = UIColor.black
            self.bugCell.backgroundColor = UIColor.black
            self.darkCell.backgroundColor = UIColor.black
            self.ghostCell.backgroundColor = UIColor.black
            self.fairyCell.backgroundColor = UIColor.black
            self.steelCell.backgroundColor = UIColor.black
            self.unknownCell.backgroundColor = UIColor.black
        }
        else {
            self.tableView.backgroundColor = UIColor.white
            self.normalCell.backgroundColor = UIColor.white
            self.fireCell.backgroundColor = UIColor.white
            self.waterCell.backgroundColor = UIColor.white
            self.fightingCell.backgroundColor = UIColor.white
            self.grassCell.backgroundColor = UIColor.white
            self.flyingCell.backgroundColor = UIColor.white
            self.electricCell.backgroundColor = UIColor.white
            self.poisonCell.backgroundColor = UIColor.white
            self.psychicCell.backgroundColor = UIColor.white
            self.groundCell.backgroundColor = UIColor.white
            self.iceCell.backgroundColor = UIColor.white
            self.rockCell.backgroundColor = UIColor.white
            self.dragonCell.backgroundColor = UIColor.white
            self.bugCell.backgroundColor = UIColor.white
            self.darkCell.backgroundColor = UIColor.white
            self.ghostCell.backgroundColor = UIColor.white
            self.fairyCell.backgroundColor = UIColor.white
            self.steelCell.backgroundColor = UIColor.white
            self.unknownCell.backgroundColor = UIColor.white
        }
    }
    
    func setEffectivenessValues(normalEffectiveness: Double, fireEffectiveness: Double, waterEffectiveness: Double, fightingEffectiveness: Double, grassEffectiveness: Double, flyingEffectiveness: Double, electricEffectiveness: Double, poisonEffectiveness: Double, psychicEffectiveness: Double, groundEffectiveness: Double, iceEffectiveness: Double, rockEffectiveness: Double, dragonEffectiveness: Double, bugEffectiveness: Double, darkEffectiveness: Double, ghostEffectiveness: Double, fairyEffectiveness: Double, steelEffectiveness: Double) {
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
        let finalMutableString = NSMutableAttributedString()
        
        if effectiveness >= 2.0 {
            let effectivenessString = NSMutableAttributedString(string: "\(effectiveness)x", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
                                                                                                         NSAttributedString.Key.foregroundColor: NOT_VERY_EFFECTIVE_COLOR])
            let toString = NSMutableAttributedString(string: "to", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                NSAttributedString.Key.foregroundColor: NOT_VERY_EFFECTIVE_COLOR])
            finalMutableString.append(effectivenessString)
            finalMutableString.append(NSMutableAttributedString(string: " (Weak ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                                NSAttributedString.Key.foregroundColor: NOT_VERY_EFFECTIVE_COLOR]))
            finalMutableString.append(toString)
            finalMutableString.append(NSMutableAttributedString(string: ")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                          NSAttributedString.Key.foregroundColor: NOT_VERY_EFFECTIVE_COLOR]))
            labelToSet.attributedText = finalMutableString
        }
        else if effectiveness < 1.0 && effectiveness > 0.0 {
            let effectivenessString = NSMutableAttributedString(string: "\(effectiveness)x", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
                                                                                                         NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR])
            let toString = NSMutableAttributedString(string: "to", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR])
            finalMutableString.append(effectivenessString)
            finalMutableString.append(NSMutableAttributedString(string: " (Resistant ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                                     NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR]))
            finalMutableString.append(toString)
            finalMutableString.append(NSMutableAttributedString(string: ")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                          NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR]))
            labelToSet.attributedText = finalMutableString

        }
        else if effectiveness == 0.0 {
            let effectivenessString = NSMutableAttributedString(string: "\(effectiveness)x", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
                                                                                                         NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR])
            let toString = NSMutableAttributedString(string: "to", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR])
            finalMutableString.append(effectivenessString)
            finalMutableString.append(NSMutableAttributedString(string: " (Immune ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                                  NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR]))
            finalMutableString.append(toString)
            finalMutableString.append(NSMutableAttributedString(string: ")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                                                          NSAttributedString.Key.foregroundColor: SUPER_EFFECTIVE_COLOR]))
            labelToSet.attributedText = finalMutableString
        }
        else {
            let effectivenessString = NSMutableAttributedString(string: "\(effectiveness)x", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22),
                                                                                                         NSAttributedString.Key.foregroundColor: NEUTRAL_EFFECTIVE_COLOR])
            finalMutableString.append(effectivenessString)

            labelToSet.attributedText = finalMutableString
        }
    }
}
