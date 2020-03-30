//
//  MainViewController.swift
//  VolgaGit
//
//  Created by John on 22.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model = MainViewModel()
        model.repositories.bind { (value) in
            self.tableView.reloadData()
        }
        
        let nibName = UINib(nibName: "RepositoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "RepositoryCell")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryTableViewCell
        
        cell.repository = model.getRepository(for: indexPath)
        
        return cell
    }
}
