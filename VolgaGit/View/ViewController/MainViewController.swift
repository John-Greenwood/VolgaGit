//
//  MainViewController.swift
//  VolgaGit
//
//  Created by John on 22.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var model: MainViewModel!
    var selectedIndexPath: IndexPath?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        model = MainViewModel(self)
        model.repositories.bind { (value) in
            if value != nil {
                self.tableView.reloadData()
                self.tableView.separatorStyle = .singleLine
                self.loader.stopAnimating()
                self.tableView.addSubview(self.refreshControl)
            }
        }
        
        let nibName = UINib(nibName: "RepositoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "RepositoryTableViewCell")
    }
    
    @objc func refresh() {
        model.loadRepositories {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        DefaultsManager.shared.login = nil
        DefaultsManager.shared.password = nil
        
        performSegue(withIdentifier: "GoToLogin", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowRepositoryDetail":
            guard
                let controller = segue.destination as? RepositoryDetailViewController,
                let selectedIndexPath = selectedIndexPath
                else { return }
            
            controller.repository = model.getRepository(for: selectedIndexPath)
        default:
            break
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        selectedIndexPath = indexPath
        
        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { () -> UIViewController? in
                let controller = self.storyboard?.instantiateViewController(identifier: "RepositoryDetail") as? RepositoryDetailViewController
                
                controller?.repository = self.model.getRepository(for: indexPath)
                
                return controller
                
        }) { (actions) -> UIMenu? in
            
            let action = UIAction(title: "Добавить в избранное", image: UIImage(systemName: "star.fill")) { (action) in
                print("SAVE!")
            }
            
            let menu = UIMenu(title: "", children: [action])
            
            return menu
        }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            self.performSegue(withIdentifier: "ShowRepositoryDetail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryTableViewCell", for: indexPath) as! RepositoryTableViewCell
        
        cell.repository = model.getRepository(for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let addToFavorites = UIContextualAction(style: .normal, title: "Добавить в избранное") { (action, view, completion) in
            completion(true)
        }
        addToFavorites.backgroundColor = .systemYellow
        addToFavorites.image = UIImage(systemName: "star.fill")
        
        
        return UISwipeActionsConfiguration(actions: [addToFavorites])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowRepositoryDetail", sender: self)
    }
}
