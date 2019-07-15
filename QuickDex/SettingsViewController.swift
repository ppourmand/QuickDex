//
//  SettingsViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/11/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTheme()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UserDefaults.standard.bool(forKey: "darkModeEnabled") ? .lightContent : .default
    }
    
    func updateTheme() {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled"){
            self.navigationBar.barTintColor = DARK_MODE_BAR_COLOR
            self.navigationBar.isTranslucent = false
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.view.backgroundColor = DARK_MODE_BAR_COLOR
        }
        else {
            self.navigationBar.barTintColor = UIColor.white
            self.view.backgroundColor = UIColor.white
            self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            self.view.backgroundColor = UIColor.white
        }
        setNeedsStatusBarAppearanceUpdate()
    }

}
