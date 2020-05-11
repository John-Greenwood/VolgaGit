//
//  DBManager.swift
//  VolgaGit
//
//  Created by John on 10.05.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit
import CoreData

class DBManager {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var context: NSManagedObjectContext {
        get { return appDelegate.persistentContainer.viewContext }
    }
    
    var model: NSManagedObjectModel {
        get { return appDelegate.persistentContainer.managedObjectModel }
    }
    
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        get {
            return appDelegate.persistentContainer.persistentStoreCoordinator
            
        }
    }
    
    static var shared: DBManager = {
        let instance = DBManager()
        return instance
    }()

    private init() {}
    
    func isSaved(_ repository: Repository) -> Bool {
        let fetch: NSFetchRequest<SavedRepository> = SavedRepository.fetchRequest()
        fetch.predicate = NSPredicate(format: "id = %@", NSNumber(value: repository.id!))
        let saves = try? context.fetch(fetch)
        
        return saves?.count ?? 0 > 0
    }
    
    func save(_ repository: Repository) {
        let savingRepository = SavedRepository(context: context)
        savingRepository.id = Int32(repository.id!)
        savingRepository.commits_url = repository.commits_url!
        savingRepository.desc = repository.description!
        savingRepository.forks_count = Int32(repository.forks_count!)
        savingRepository.full_name = repository.full_name!
        savingRepository.language = repository.language
        savingRepository.name = repository.name!
        savingRepository.owner = repository.owner!.login!
        savingRepository.ownerAvatar = repository.owner!.avatar_url!
        savingRepository.ownerId = Int32(repository.owner!.id!)
        savingRepository.stargazers_count = Int32(repository.stargazers_count!)
        savingRepository.watchers_count = Int32(repository.watchers_count!)
        
        try? context.save()
    }
    
    func delete(_ repository: Repository) {
        let fetch: NSFetchRequest<SavedRepository> = SavedRepository.fetchRequest()
        fetch.predicate = NSPredicate(format: "id = %@", NSNumber(value: repository.id!))
        let fetchResults = try! context.fetch(fetch)
        
        let save = fetchResults.first
        
        context.delete(save!)
    }
    
    func getSaves() -> [Repository] {
        let fetch: NSFetchRequest<SavedRepository> = SavedRepository.fetchRequest()
        let saves = try! context.fetch(fetch)
        
        var result: [Repository] = []
        
        for save in saves {
            let repository = Repository(
                message: nil,
                id: Int(save.id),
                name: save.name,
                full_name: save.full_name,
                owner: Repository.Owner(login: save.owner,
                                        id: Int(save.ownerId),
                                        avatar_url: save.ownerAvatar),
                description: save.desc,
                commits_url: save.commits_url,
                stargazers_count: Int(save.stargazers_count),
                watchers_count: Int(save.watchers_count),
                language: save.language,
                forks_count: Int(save.forks_count))
            
            result.append(repository)
        }
        
        return result
    }
}
