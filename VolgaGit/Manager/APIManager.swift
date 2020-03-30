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
    let apiurl = "https://api.github.com/"
    
    func fetchRepositories(
        completion: @escaping (
        _ success: Bool,
        _ error: AlertManager.Error?,
        _ repositories: [Repository]?
        )->()) {
        AF.request("\(apiurl)repositories").responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                do {
                    let result = try self.decoder.decode([RepositoriesResponse].self, from: data)
                    
                    var repositories: [Repository] = []
                    
                    for repository in result {
                        self.getRepository(with: repository.full_name!) { (result, error, repo) in
                            if result { repositories.append(repo!) }
                            completion(true, nil, repositories)
                        }
                    }
                    
                } catch {
                    completion(false, .server, nil)
                }
                
            case .failure(_):
                completion(false, .network, nil)
            }
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
    
    func getRepository(with name: String, completion: @escaping (
        _ success: Bool,
        _ error: AlertManager.Error?,
        _ repository: Repository?
        )->()) {
        
        let username = DefaultsManager.shared.login ?? "login"
        let password = DefaultsManager.shared.password ?? "pass"

        let credentialData = "\(username):\(password)".data(using: .utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers: HTTPHeaders = ["Authorization": "Basic \(base64Credentials)"]
        
        AF.request("\(apiurl)repos/\(name)", headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                
                do {
                    let repo = try self.decoder.decode(GetRepository.self, from: data)
                    
                    if repo.message == nil {
                        self.loadImage(url: repo.owner?.avatar_url ?? "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png") { (image) in
                            
                            let repository = Repository(
                            title: repo.full_name!,
                            description: repo.description ?? "",
                            userAvatar: image,
                            authorName: repo.owner!.login!,
                            forksCount: repo.forks!,
                            starsCount: repo.stargazers_count!,
                            language: repo.language ?? "-")

                            completion(true, nil, repository)
                        }
                        
                    } else {
                        completion(false, .needAuth, nil)
                        print(repo.message!)
                    }
                    
                } catch { completion(false, .server, nil) }
                
            case .failure(_):
                completion(false, .network, nil)
            }
        }
    }
}
