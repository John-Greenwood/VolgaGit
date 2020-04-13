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
    @IBOutlet weak var languageImage: UIImageView!
    
    @IBOutlet var loadingViews: [UIView]!
    
    var repository: Repository? {
        didSet { configure() }
    }
    
    func configure() {
        guard let repository = repository else { return }
        
        titleLabel.text = repository.name
        descriptionLabel.text = repository.description
        userNameLabel.text = repository.owner?.login
        languageLabel.text = repository.language ?? "Unknown"
        forkCountLabel.text = "\(repository.forks_count ?? 0)"
        starCountLabel.text = "\(repository.stargazers_count ?? 0)"
        
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
        
        if let avatarurl = repository.owner?.avatar_url {
            APIManager.shared.loadImage(url: avatarurl) { (image) in
                self.userImage.image = image
            }
        }
        
        let color = LanguageColors.getColor(for: repository)
        languageImage.tintColor = color
        languageLabel.textColor = color
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
