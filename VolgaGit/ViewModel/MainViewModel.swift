//
//  MainViewModel.swift
//  VolgaGit
//
//  Created by John on 22.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation

class MainViewModel {
    
    var repositories: Box<[Repository]?> = Box(nil)
    var repositoriesCount: Int { get { return repositories.value?.count ?? 0 }}
    
    init() {
        loadRepositories()
    }
    
    func getRepository(for indexPath: IndexPath) -> Repository {
        return (repositories.value?[indexPath.row])!
    }
    
    func loadRepositories() {
        repositories.value = [
            Repository(title: "Repo one", description: "Test test test test Test test test test Test test test test Test test test test Test test test test Test test test test Test test Test test test test Test test test test ", userAvatar: .remove, authorName: "John Doe", forksCount: 123, starsCount: 321, language: "Swift"),
             Repository(title: "Repo one", description: "Test test test test Test test test test Test test test test Test test test test Test test test test Test test test test Test test Test test test test Test test test test ", userAvatar: .remove, authorName: "John Doe", forksCount: 123, starsCount: 321, language: "Swift"),
              Repository(title: "Repo one", description: "Test test test test Test test test test Test test test test Test test test test Test test test test Test test test test Test test Test test test test Test test test test ", userAvatar: .remove, authorName: "John Doe", forksCount: 123, starsCount: 321, language: "Swift"),
               Repository(title: "Repo one", description: "Test test test test Test test test test Test test test test Test test test test Test test test test Test test test test Test test Test test test test Test test test test ", userAvatar: .remove, authorName: "John Doe", forksCount: 123, starsCount: 321, language: "Swift")
        ]
    }
}
