//
//  ReposViewController.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReposViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var repos: [Repo]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Repos"
        
        self.tableView.register(UINib(nibName: "RepoTableViewCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyRepos()
    }
    
    func fetchMyRepos() {
        Repo.getMyRepos( completionHandler: { (fetchedRepos, error) in
            if let receivedError = error {
                print(receivedError)
                GitHubAPIManager.sharedInstance.OAuthToken = nil
                // TODO: display error
            } else {
                self.repos = fetchedRepos
                for (index, repo) in fetchedRepos.enumerated() {
                    self.getLesImages(repo: repo) {
                        if index == fetchedRepos.count - 1 {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    func getLesImages(repo: Repo, _ completion: @escaping () -> Void) {
        repo.getTest(url: repo.avatarURL!, { (image) in
            repo.avatarImage = image
            completion()
        })
    }
}

extension ReposViewController: UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoTableViewCell {
            if let repoSite = self.repos?[indexPath.row] {
                cell.repo = repoSite
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension ReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let repo = self.repos?[indexPath.row] {
            
            let storyboard = UIStoryboard(name: "Branches", bundle: nil)
            let controller = storyboard.instantiateInitialViewController() as! BranchesViewController
            controller.repo = repo
        
            self.navigationController?.pushViewController(controller, animated: true)
        
        }
    }
}
