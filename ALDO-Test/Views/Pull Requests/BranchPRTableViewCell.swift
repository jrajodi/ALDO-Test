//
//  BranchPRTableViewCell.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

protocol BranchPRTableViewCellPresenter {
    func getPRNumber() -> String?
    func getPRName() -> String?
    func getPRCreatedAt() -> String?
    func getStatus() -> String?
}

class BranchPRTableViewCell: UITableViewCell {

    @IBOutlet weak var prNumber: UILabel!
    @IBOutlet weak var prName: UILabel!
    @IBOutlet weak var prCreatedAt: UILabel!
    @IBOutlet weak var prStatus: UILabel!
    
    var branchPR: BranchPRTableViewCellPresenter? {
        didSet {
            if let branchPR = self.branchPR {
                self.prNumber.text = branchPR.getPRNumber()
                self.prName.text = branchPR.getPRName()
                self.prCreatedAt.text = branchPR.getPRCreatedAt()
                self.prStatus.text = branchPR.getStatus()
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

extension BranchPR: BranchPRTableViewCellPresenter {
    func getPRCreatedAt() -> String? {
        if let prCreatedAt = self.prCreatedAt {
            return prCreatedAt
        }
        return nil
    }
    
    func getPRNumber() -> String? {
        if let prNumber = self.prNumber {
            return String(prNumber)
        }
        return nil
    }
    
    func getPRName() -> String? {
        if let prName = self.prName {
            return prName
        }
        return nil
    }
    
    func getStatus() -> String? {
        if let prStatus = self.prStatus {
            return prStatus
        }
        return nil
    }
}
