//
//  RepositoryDetailViewController.swift
//  VolgaGit
//
//  Created by John on 31.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var repository: Repository?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRepository()
    }
    
    func showRepository() {
        guard let repository = repository else { return }
        
        title = repository.name
        textLabel.text = "There is will be details of \(repository.name ?? "") repository made by \(repository.owner?.login ?? "")"
    }
}
