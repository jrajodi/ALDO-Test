//
//  Branch.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Branch {
    var name: String?
    var sha: String?
    var messageSHA: String?
    
    init(json: JSON) {
        self.name = json["name"].string
        self.sha = json["commit"]["sha"].string
        self.messageSHA = json["commit"]["message"].string
    }
    
    class func getRepoBranches(repo: String, owner: String, completionHandler: @escaping ([Branch]?, Error?) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/branches"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Branches: \(json)")
                        
                        var branches = [Branch]()
                        for (_, branchJson) in json {
                            print(branchJson)
                            let branch = Branch(json: branchJson)
                            branches.append(branch)
                        }
                        completionHandler(branches, nil)
                    }
                    
                case .failure(let error):
                    //                    AlertUtilities.presentAlert("Login", message: error.localizedDescription)
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler(nil, error)
                }
        }
    }
}
