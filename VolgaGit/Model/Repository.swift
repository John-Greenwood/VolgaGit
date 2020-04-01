//
//  GetRepository.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation

struct Repository: Codable {
    
    let message: String?
    
    let id: Int?
    let name: String?
    let full_name: String?
    let owner: Owner?
    let description: String?
    let commits_url: String?
    let stargazers_count: Int?
    let watchers_count: Int?
    let language: String?
    let forks_count: Int?
    
    struct Owner: Codable {
        let login: String?
        let id: Int?
        let avatar_url: String?
    }
}
