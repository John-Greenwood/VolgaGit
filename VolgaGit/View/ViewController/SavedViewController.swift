//
//  SavedViewController.swift
//  VolgaGit
//
//  Created by John on 08.05.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

import UIKit
import SkeletonView

class SavedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var model: SavedViewModel!
    var selectedIndexPath: IndexPath?
    let refreshControl = UIRefreshControl()
    var isLoading = true
    let cellIdentifier = "RepositoryTableViewCell"
    var seagueIdentifier = "ShowSavedRepositoryDetail"
    var pagination = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "RepositoryTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
        
        tableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        model = SavedViewModel(self)
        model.repositories.bind { (value) in
            if value?.isEmpty ?? false {
                self.endLoading()
                
            } else if value != nil {
                self.endLoading()
                self.tableView.separatorStyle = .singleLine
            }
        }
        
        model.savedRepositories.bind { (value) in
            self.tableView.reloadData()
        }
    }
    
    func loadNextRepositories () {
        pagination = false
        tableView.reloadSections([2], with: .bottom)
        model.loadRepositories { (_) in
            self.pagination = true
            self.tableView.reloadSections([2], with: .bottom)
        }
    }
    
    func endLoading() {
        isLoading = false
        tableView.reloadData()
        tableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh() {
        model.loadRepositories(true) { result in
            self.refreshControl.endRefreshing()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case seagueIdentifier:
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

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if isLoading || indexPath.section == 2 { return nil }

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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Сохраненные репозитории" }
        else if section == 1 { return "Смотрите также" }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            self.performSegue(withIdentifier: self.seagueIdentifier, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return model.savedRepositoriesCount }
        if section == 2 { return 1 }
        if isLoading { return 5 }
        else { return model.repositoriesCount }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
            if pagination { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "loader") ?? UITableViewCell()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RepositoryTableViewCell
        
        
        
        if isLoading {
            cell.showAnimatedGradientSkeleton()
            
        } else {
            cell.hideSkeleton()
            if indexPath.section == 0 {
                cell.repository = model.getSavedRepository(for: indexPath)
            } else {
                cell.repository = model.getRepository(for: indexPath)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if isLoading || indexPath.section == 1 { return nil }
        
        let addToFavorites = UIContextualAction(style: .normal, title: "Добавить в избранное") { (action, view, completion) in
            completion(true)
        }
        addToFavorites.backgroundColor = .systemYellow
        addToFavorites.image = UIImage(systemName: "star.fill")
        
        
        return UISwipeActionsConfiguration(actions: [addToFavorites])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isLoading || indexPath.section == 2 { return }
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: seagueIdentifier, sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0, pagination {
            loadNextRepositories()
        }
    }
}
