//
//  SettingsViewController.swift
//  VolgaGit
//
//  Created by John on 08.05.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        }
    }
    
    @IBOutlet weak var accountLabel: UILabel! {
        didSet {
            accountLabel.text = "\(DefaultsManager.shared.login ?? "Повторите вход")"
        }
    }

    @IBAction func logOut(_ sender: Any) {
        DefaultsManager.shared.login = nil
        DefaultsManager.shared.password = nil
        
        performSegue(withIdentifier: "LogOut", sender: self)
    }
}
