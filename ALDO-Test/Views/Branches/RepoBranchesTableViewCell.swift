//
//  RepoBranchesTableViewCell.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

protocol RepoBranchesTableViewCellPresenter {
    func getBranchName() -> String?
    func getSHA() -> String?
}

class RepoBranchesTableViewCell: UITableViewCell {

    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var lastSHA: UILabel!
    
    var repoBranch: RepoBranchesTableViewCellPresenter? {
        didSet {
            if let repoBranch = self.repoBranch {
                self.branchName.text = repoBranch.getBranchName()
                self.lastSHA.text = repoBranch.getSHA()
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
    
}

extension Branch: RepoBranchesTableViewCellPresenter {
    func getBranchName() -> String? {
        if let branchName = self.name {
            return branchName
        }
        return nil
    }
    
    func getSHA() -> String? {
        if let lastSHA = self.sha {
            return lastSHA
        }
        return nil
    }
    
}
