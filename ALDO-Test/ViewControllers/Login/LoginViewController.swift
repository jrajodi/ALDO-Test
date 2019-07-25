//
//  ViewController.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (GitHubAPIManager.sharedInstance.hasOAuthToken()) {
            redirectToRepoScreen()
        }
    }

    @IBAction func loginDidTap(_ sender: Any) {
        redirectToGithub()
    }
    
    func redirectToGithub() {
        if (!GitHubAPIManager.sharedInstance.hasOAuthToken()) {
            GitHubAPIManager.sharedInstance.oauthTokenCompletionHandler = {
                (error) -> Void in
                if let receivedError = error {
                    print(receivedError)
                    // TODO: handle error
                    // TODO: issue: don't get unauthorized if we try this query
                    GitHubAPIManager.sharedInstance.startOAuth2Login()
                } else {
                    self.redirectToRepoScreen()
                }
            }
            GitHubAPIManager.sharedInstance.startOAuth2Login()
        } else {
            redirectToRepoScreen()
        }
    }
    
    func redirectToRepoScreen() {
        let storyboard = UIStoryboard(name: "Repos", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()!
        self.present(controller, animated: true, completion: nil)
    }
    
}

