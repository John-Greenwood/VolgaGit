//
//  APIManager.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    
    static var shared: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    private init() {}
    
    let decoder = JSONDecoder()
    
    func fetchRepositories(completion: @escaping (_ success: Bool, _ error: AlertManager.Error?, _ repositories: [Repository]?)->()) {
        gitApi(method: "repositories") { (result, data) in
            if result {
                do {
                    let result = try self.decoder.decode([Repository].self, from: data!)
                    
                    var repositories: [Repository] = []
                    
                    let group = DispatchGroup()
                    
                    for repository in result {
                        group.enter()
                        
                        self.getRepository(with: repository.full_name!) { (result, error, repository) in
                            if result { repositories.append(repository!) }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: .main) { completion(true, nil, repositories) }
                    
                } catch { completion(false, .needAuth, nil) }
                
            } else { completion(false, .network, nil) }
        }
    }
    
    func getRepository(with name: String, completion: @escaping (_ success: Bool, _ error: AlertManager.Error?, _ repository: Repository?)->()) {
        gitApi(method: "repos/\(name)") { (result, data) in
            if result {
                do {
                    let repository = try self.decoder.decode(Repository.self, from: data!)
                    if repository.message == nil { completion(true, nil, repository) }
                    else { completion(false, .needAuth, nil) }
                    
                } catch { completion(false, .server, nil) }
                
            } else { completion(false, .network, nil) }
        }
    }
    
    func loadImage(url: String, completion: @escaping (_ image: UIImage?)->()) {
        AF.request(url).responseData { (response) in
            switch response.result {
            case .success(_):
                completion(UIImage(data: response.data!)!)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func gitApi(method: String, completion: @escaping (_ result: Bool, _ data: Data?)->()) {
        let apiurl = "https://api.github.com/"
        
        let username = DefaultsManager.shared.login ?? "login"
        let password = DefaultsManager.shared.password ?? "pass"
        let credentialData = "\(username):\(password)".data(using: .utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]

        AF.request("\(apiurl)\(method)", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_): completion(true, response.data)
            case .failure(_): completion(false, nil)
            }
        }
    }
}
