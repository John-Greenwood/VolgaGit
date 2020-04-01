//
//  LoginViewController.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        DefaultsManager.shared.login = loginField.text
        DefaultsManager.shared.password = passwordField.text
    }
}
