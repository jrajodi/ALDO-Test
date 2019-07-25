//
//  RepoTableViewCell.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

protocol RepoTableViewCellPresenter {
    func getName() -> String?
    func getType() -> String?
    func getAvatarImage() -> UIImage?
}

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoType: UILabel!
    
    var repo: RepoTableViewCellPresenter? {
        didSet {
            if let repo = self.repo {
                self.repoName.text = repo.getName()
                self.repoType.text = repo.getType()
                self.avatarImage.image = repo.getAvatarImage()
            } else {
                self.prepareForReuse()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        self.repoName.text = nil
        self.repoType.text = nil
        self.avatarImage.image = nil
    }
}

extension Repo: RepoTableViewCellPresenter {
    func getAvatarImage() -> UIImage? {
        if let avatarImage = self.avatarImage {
            return avatarImage
        }
        return nil
    }
    
    
    func getName() -> String? {
        if let name = self.name {
            return name
        }
        return nil
    }
    
    func getType() -> String? {
        if let type = self.type {
            return type
        }
        return nil
    }
}
