//
//  Repo.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Repo {
    var id: Int?
    var name: String?
    var description: String?
    var ownerLogin: String?
    var url: String?
    var avatarURL: String?
    var type: String?
    var avatarImage: UIImage?

    init(id: Int, name: String, description: String, ownerLogin: String, url: String, avatarURL: String, type: String, avatarImage: UIImage) {
        self.id = id
        self.name = name
        self.description = description
        self.ownerLogin = ownerLogin
        self.url = url
        self.avatarURL = avatarURL
        self.type = type
        self.avatarImage = avatarImage
    }
    
    required init(json: JSON) {
        
        self.avatarURL = json["owner"]["avatar_url"].string
        self.description = json["description"].string
        self.id = json["id"].int
        self.name = json["name"].string
        self.ownerLogin = json["owner"]["login"].string
        self.url = json["url"].string
        let forkType = json["fork"].bool ?? false
        let privateType = json["private"].bool ?? false
        self.type = forkType ? "Fork" : privateType ? "Private" : "Public"
    }

    class func getAvatarOne(url: String, _ completion: @escaping (UIImage?) -> Void) {
        self.getAvatarImage(url: url,
                            success: { (image) in
                                completion(image)
        },
                            failure: {
                                completion(nil)
        })
    }
    
    class func getAvatarImages(repoList: [Repo], completionHandler: @escaping ([Repo]?) -> Void) {
        for repo in repoList {
            let avatarURL = repo.avatarURL
            self.getAvatarOne(url: avatarURL!) { (image) in
                repo.avatarImage = image
            }
        }
        completionHandler(repoList)

    }
    
    class func getMyRepos(completionHandler: @escaping ([Repo], Error?) -> Void) {
        let path = "https://api.github.com/user/repos"
        
        GitHubAPIManager.sharedInstance.alamofireManager().request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("Repos: \(json)")
                        
                        var repos = [Repo]()
                        for (key, jsonRepo) in json {
                            print(key)
                            print(jsonRepo)
                            let repo = Repo(json: jsonRepo)
                            
                            repos.append(repo)
                        }
                        completionHandler(repos, nil)
                    }
                    
                case .failure(let error):
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    
                    // TODO: parse out errors more specifically
                    completionHandler([Repo](), error)
                }
        }
    }
    
    func getImageAvatar(url: String, _ completion: @escaping (UIImage) -> Void) {
        self.getTest(url: url, { (image) in
            completion(image)
        })
    }

    class func getAvatarImage(url: String, success: @escaping (UIImage?) -> Void, failure: @escaping () -> Void) {
        GitHubAPIManager.sharedInstance.alamofireManager().request(url)
            .validate()
            .responseData { response in
                switch response.result {
                    
                case .success:
                    if let value = response.result.value {
                        if let avatarDecoded = UIImage(data: value) {
                            success(avatarDecoded)
                        }
                    }
                    
                case .failure(let error):
                    print("Not working")
                    print(response.request as Any)
                    print(response)
                    print(response.data as Any)
                    print(error.localizedDescription)
                    print("Erreur: \(error.localizedDescription)")
                    failure()
                }
        }
    }
    
    func getTest(url: String, _ completion: @escaping (UIImage) -> Void) {
        Repo.getAvatarImage(url: url, success: { (image) in
            completion(image!)
        }) {
            
        }
        
    }
}
