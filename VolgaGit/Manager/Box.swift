//
//  Box.swift
//  VolgaGit
//
//  Created by John on 25.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}
