//
//  PRsViewController.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

class PRsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var branch: Branch!
    
    var repo: Repo!
    
    var prlist: [BranchPR]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pull Requests"
        self.tableView.register(UINib(nibName: "BranchPRTableViewCell", bundle: nil), forCellReuseIdentifier: "BranchPRCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchBranchPR(repo: repo)
    }
    
    func fetchBranchPR(repo: Repo!) {
        if let repoName = repo.name,
            let owner = repo.ownerLogin {
            BranchPR.getBranchPR(repo: repoName, owner: owner) { (branchPR, error) in
                self.prlist = branchPR
                self.tableView.reloadData()
            }
        }
    }
    
}

extension PRsViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prlist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BranchPRCell", for: indexPath) as? BranchPRTableViewCell {
            if let branchPR = self.prlist?[indexPath.row] {
                cell.branchPR = branchPR
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
