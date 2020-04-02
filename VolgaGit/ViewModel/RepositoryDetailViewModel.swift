//
//  RepositoryDetailViewModel.swift
//  VolgaGit
//
//  Created by John on 01.04.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class RepositoryDetailViewModel {
    
    let target: UIViewController
    let repository: Repository
    
    var commits: Box<[Commit]?> = Box(nil)
    var commitsCount: Int { get { return commits.value?.count ?? 0} }
    
    init(_ target: UIViewController, repository: Repository) {
        self.target = target
        self.repository = repository
        
        loadCommits {}
    }
    
    func getCommit(for indexPath: IndexPath) -> Commit {
        return commits.value![indexPath.row]
    }
    
    func loadCommits(completion: @escaping ()->()) {
        APIManager.shared.getCommits(for: repository) { (success, error, commits) in
            if success { self.commits.value = commits }
            else { AlertManager(self.target).error(error!) }
            
            completion()
        }
    }
}
