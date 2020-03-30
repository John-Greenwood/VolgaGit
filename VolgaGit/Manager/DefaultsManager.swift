//
//  DefaultsManager.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation

class DefaultsManager {
    static var shared: DefaultsManager = {
        let instance = DefaultsManager()
        return instance
    }()

    private init() {}
    
    let defaults = UserDefaults.standard
    
    var login: String? {
        get { return defaults.string(forKey: "login") }
        set { defaults.set(newValue, forKey: "login") }
    }
    
    var password: String? {
        get { return defaults.string(forKey: "password") }
        set { defaults.set(newValue, forKey: "password") }
    }
}
