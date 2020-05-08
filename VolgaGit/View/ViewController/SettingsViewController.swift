//
//  SettingsViewController.swift
//  VolgaGit
//
//  Created by John on 08.05.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel! {
        didSet {
            accountLabel.text = "Используется аккаунт: \(DefaultsManager.shared.login ?? "")"
        }
    }

    @IBAction func logOut(_ sender: Any) {
        DefaultsManager.shared.login = nil
        DefaultsManager.shared.password = nil
        
        performSegue(withIdentifier: "LogOut", sender: self)
    }
}
