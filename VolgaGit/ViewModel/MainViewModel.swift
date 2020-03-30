//
//  MainViewModel.swift
//  VolgaGit
//
//  Created by John on 22.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class MainViewModel {
    
    var repositories: Box<[Repository]?> = Box(nil)
    var repositoriesCount: Int { get { return repositories.value?.count ?? 0 }}
    let target: UIViewController
    var alertManager: AlertManager!
    
    init(_ target: UIViewController) {
        self.target = target
        self.alertManager = AlertManager(target)
        loadRepositories()
    }
    
    func getRepository(for indexPath: IndexPath) -> Repository {
        return (repositories.value?[indexPath.row])!
    }
    
    func loadRepositories() {
        APIManager.shared.fetchRepositories { (result, error, repositories) in
            if result { self.repositories.value = repositories! }
            else { self.alertManager.error(error!) }
        }
    }
}
