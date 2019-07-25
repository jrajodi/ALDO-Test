//
//  PR.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BranchPR {
    var prNumber: Int?
    var prName: String?
    var prCreatedAt: String?
    var prStatus: String?
    
    init(json: JSON) {
        self.prNumber = json["number"].int
        self.prName = json["title"].string
        self.prCreatedAt = json["created_at"].string
        self.prStatus = json["state"].string
    }
    
    class func getBranchPR(repo: String, owner: String, completionHandler: @escaping ([BranchPR]?, Error?) -> Void) {
        let path = "https://api.github.com/repos/\(owner)/\(repo)/pulls"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("PR: \(json)")
                        
                        var branchPRs = [BranchPR]()
                        for (_, branchJson) in json {
                            print(branchJson)
                            let branchPR = BranchPR(json: branchJson)
                            branchPRs.append(branchPR)
                        }
                        completionHandler(branchPRs, nil)
                    }
                    
                case .failure(let error):
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
