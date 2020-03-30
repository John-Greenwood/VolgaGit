//
//  AlertManager.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class AlertManager {
    
    let target: UIViewController
    
    init(_ target: UIViewController) {
        self.target = target
    }
    
    enum Error: String {
        case network = "Ошибка сети, проверьте сетевое подключение и попробуйте снова.",
        server = "Ошибка сервера, попробуйте позже.",
        needAuth = "Необходима авторизация для продолжения использования!"
    }
    
    func error(_ error: Error) {
        alert(title: "Ошибка", message: error.rawValue, actions: [
            UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        ])
    }
    
    func alert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        target.present(alertController, animated: true)
    }
}
