//
//  BranchesViewController.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

class BranchesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var repo: Repo! {
        didSet {
            self.fetchRepoBranches(repo: repo)
        }
    }
    
    var brancheslist: [Branch]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Branches"
        self.tableView.register(UINib(nibName: "RepoBranchesTableViewCell", bundle: nil), forCellReuseIdentifier: "BranchCell")
    }
    
    func fetchRepoBranches(repo: Repo) {
        Branch.getRepoBranches(repo: repo.name!, owner: repo.ownerLogin!) { (repoBranches, error) in
            self.brancheslist = repoBranches
            self.tableView.reloadData()
        }
    }
    
}

extension BranchesViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brancheslist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as? RepoBranchesTableViewCell {
            if let repoBranch = self.brancheslist?[indexPath.row] {
                cell.repoBranch = repoBranch
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension BranchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let branch = self.brancheslist?[indexPath.row] {
            
            let storyboard = UIStoryboard(name: "PRs", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! PRsViewController
            controller.repo = repo
            controller.branch = branch
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
