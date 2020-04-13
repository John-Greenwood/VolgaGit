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
    var lastRepositoryIdentifier: Int? = nil
    
    init(_ target: UIViewController) {
        self.target = target
        self.alertManager = AlertManager(target)
        loadRepositories{ _ in }
    }
    
    func getRepository(for indexPath: IndexPath) -> Repository {
        return (repositories.value?[indexPath.row])!
    }
    
    func loadRepositories(_ clear: Bool = false, completion: @escaping (_ result: Bool)->()) {
        APIManager.shared.fetchRepositories(lastIdentifier: lastRepositoryIdentifier) { (result, error, repositories) in
            if clear { self.repositories.value = [] }
            if self.repositories.value == nil { self.repositories.value = [] }
            if result {
                self.repositories.value?.append(contentsOf: repositories!)
                self.lastRepositoryIdentifier = self.repositories.value?.last?.id
                
            } else {
                self.repositories.value = []
                if error! == .needAuth { AlertManager(self.target).error(error!) }
            }
            
            completion(result)
        }
    }
}
