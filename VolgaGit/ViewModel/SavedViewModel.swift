//
//  SavedViewModel.swift
//  VolgaGit
//
//  Created by John on 09.05.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class SavedViewModel: MainViewModel {
    
    override func loadRepositories(_ clear: Bool = false, completion: @escaping (Bool) -> ()) {
        APIManager.shared.fetchRepositories(lastIdentifier: lastRepositoryIdentifier, method: "orgs/github/repos") { (result, error, repositories) in
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
    
    var savedRepositories: Box<[Repository]?> = Box(nil)
    var savedRepositoriesCount: Int { get { return savedRepositories.value?.count ?? 0 }}
    
    override init(_ target: UIViewController) {
        super.init(target)
        
        // Temp, change it
        self.savedRepositories.value = []
    }
    
    func getSavedRepository(for indexPath: IndexPath) -> Repository {
        return (savedRepositories.value?[indexPath.row])!
    }
    
    override func getRepository(for indexPath: IndexPath) -> Repository {
        if indexPath.section == 0 { return getSavedRepository(for: indexPath) }
        else { return super.getRepository(for: indexPath) }
    }
}
