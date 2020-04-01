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
        performSegue(withIdentifier: "ShowMainScreen", sender: nil)
    }


}
