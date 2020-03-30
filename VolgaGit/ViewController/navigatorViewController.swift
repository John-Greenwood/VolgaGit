//
//  ViewController.swift
//  VolgaGit
//
//  Created by John on 22.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class navigatorViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if DefaultsManager.shared.login != nil, DefaultsManager.shared.password != nil { performSegue(withIdentifier: "ShowMainScreen", sender: self) }
        else { performSegue(withIdentifier: "ShowLoginScreen", sender: self) }
        
    }
}
