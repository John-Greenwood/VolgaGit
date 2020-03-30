//
//  RepositoryTableViewCell.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    
    var repository: Repository? {
        didSet {
            guard let repository = repository else { return }
            
            titleLabel.text = repository.title
            descriptionLabel.text = repository.description
            userImage.image = repository.userAvatar
            userNameLabel.text = repository.authorName
            languageLabel.text = repository.language
            forkCountLabel.text = "\(repository.forksCount)"
            starCountLabel.text = "\(repository.starsCount)"
            
            userImage.layer.cornerRadius = userImage.frame.size.height / 2
        }
    }
}
