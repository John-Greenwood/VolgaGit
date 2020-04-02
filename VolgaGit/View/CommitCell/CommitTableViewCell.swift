//
//  CommitTableViewCell.swift
//  VolgaGit
//
//  Created by John on 01.04.2020.
//  Copyright © 2020 Лебедев Лев. All rights reserved.
//

import UIKit

@IBDesignable class CommitTableViewCell: UITableViewCell {
    
    var backgrounView: UIView?
    @IBInspectable var nibName: String?

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var circle: UIView!
    
    var commit: Commit? {
        didSet {
            guard let commit = commit else { return }
            
            messageLabel.text = commit.commit?.message
            dateLabel.text = commit.commit?.committer?.date
            
            if let gitUser = commit.author {
                usernameLabel.text = gitUser.login
                APIManager.shared.loadImage(url: gitUser.avatar_url!) { (image) in
                    self.userImage.image = image
                }
            } else {
                usernameLabel.text = "\(commit.commit?.committer?.name ?? "") (\(commit.commit?.committer?.email ?? ""))"
            }
            
            circle.layer.cornerRadius = circle.layer.bounds.height / 2
            userImage.layer.cornerRadius = userImage.layer.bounds.height / 2
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
