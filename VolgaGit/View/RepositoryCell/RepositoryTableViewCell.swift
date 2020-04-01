//
//  RepositoryTableViewCell.swift
//  VolgaGit
//
//  Created by John on 30.03.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

@IBDesignable class RepositoryTableViewCell: UITableViewCell {
    
    var backgrounView: UIView?
    @IBInspectable var nibName: String?

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
            
            titleLabel.text = repository.name
            descriptionLabel.text = repository.description
//            userImage.image = repository.userAvatar
            userNameLabel.text = repository.owner?.login
            languageLabel.text = repository.language
            forkCountLabel.text = "\(repository.forks_count ?? 0)"
            starCountLabel.text = "\(repository.stargazers_count ?? 0)"
            
            userImage.layer.cornerRadius = userImage.frame.size.height / 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        backgrounView = view
    }
    
    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        backgrounView?.prepareForInterfaceBuilder()
    }
}
