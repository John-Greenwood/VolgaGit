//
//  Commit.swift
//  VolgaGit
//
//  Created by John on 01.04.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation

struct Commit: Codable {
    
    let commit: Contents?
    let author: Autor?
    
    struct Autor: Codable {
        let login: String?
        let avatar_url: String?
    }
    
    struct Contents: Codable {
        
        let message: String?
        let committer: Committer?
        
        struct Committer: Codable {
            let name: String?
            let email: String?
            let date: String?
        }
    }
}
