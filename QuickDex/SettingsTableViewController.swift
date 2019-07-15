//
//  SettingsTableViewController.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 7/9/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var aboutIconCell: UITableViewCell!
    @IBOutlet weak var myTwitterCell: UITableViewCell!
    @IBOutlet weak var darkModeCell: UITableViewCell!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var settingsNavigationBar: UINavigationBar!
    @IBOutlet weak var darkModeToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.darkModeToggle.isOn = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        self.setTheme()
    }
    
    @IBAction func enableDarkMode(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(darkModeToggle.isOn, forKey: "darkModeEnabled")
        self.setTheme()
    }
    
    @IBAction func goToMyTwitter(_ sender: Any) {
        let myTwitterPage = NSURL(string:"https://twitter.com/pashapourmand")! as URL
        UIApplication.shared.open(myTwitterPage, options: [:], completionHandler: nil)
    }
    
    @IBAction func goToIcon8LicensePage(_ sender: Any) {
        let icons8Url = NSURL(string:"https://icons8.com")! as URL
        UIApplication.shared.open(icons8Url, options: [:], completionHandler: nil)
    }

    func setTheme() {
        if UserDefaults.standard.bool(forKey: "darkModeEnabled") {
            print("enable dark mode")
            self.tabBarController?.tabBar.barTintColor = DARK_MODE_BAR_COLOR
            self.tabBarController?.tabBar.isTranslucent = false
            settingsNavigationBar.barTintColor = DARK_MODE_BAR_COLOR
            settingsNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.tableView.backgroundColor = UIColor.black
            self.navigationController?.navigationBar.barTintColor = DARK_MODE_BAR_COLOR
            aboutIconCell.backgroundColor = UIColor.black
            myTwitterCell.backgroundColor = UIColor.black
            darkModeCell.backgroundColor = UIColor.black
            darkModeLabel.textColor = UIColor.white
            
            guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
                return
            }
            statusBarView.backgroundColor = DARK_MODE_BAR_COLOR
        }
        else {
            print("enable light mode")
            self.tableView.backgroundColor = UIColor.white
            self.tabBarController?.tabBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            settingsNavigationBar.barTintColor = UIColor.white
            settingsNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            self.view.backgroundColor = UIColor.white
            aboutIconCell.backgroundColor = UIColor.white
            myTwitterCell.backgroundColor = UIColor.white
            darkModeCell.backgroundColor = UIColor.white
            darkModeLabel.textColor = UIColor.black
            
            guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
                return
            }
            statusBarView.backgroundColor = UIColor.white
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UserDefaults.standard.bool(forKey: "darkModeEnabled") ? .lightContent : .default
    }
}
