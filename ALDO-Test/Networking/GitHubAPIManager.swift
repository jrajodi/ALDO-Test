//
//  GitHubAPIManager.swift
//  ALDO-Test
//
//  Created by Jignesh Rajodiya on 2019-07-24.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class GitHubAPIManager {
    
    static let sharedInstance = GitHubAPIManager()
    
    var clientID: String = "404b80d1f94684b78eaf"
    var clientSecret: String = "6687e67992033c7f4d9fcb6faceb6f02ffca665e"
    var OAuthToken: String? {
        set {
            if let valueToSave = newValue {
                do {
                    try Locksmith.saveData(data: ["token": valueToSave], forUserAccount: "github")
                } catch _ {
                    do {
                        try Locksmith.deleteDataForUserAccount(userAccount: "github")
                    } catch _ {}
                }
            } else { // they set it to nil, so delete it
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "github")
            } catch _ {}
                removeSessionHeaderIfExists(key: "Authorization")
            }
        }
        get {
            // try to load from keychain
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: "github")
             if let token =  dictionary?["token"] as? String {
                return token
            }
            removeSessionHeaderIfExists(key: "Authorization")
            return nil
        }
    }
    // handlers for the oauth process
    // stored as vars since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var oauthTokenCompletionHandler:((Error?) -> Void)?
    
    func addSessionHeader(key: String, value: String) {
        let manager = Alamofire.SessionManager.default
        if var sessionHeaders = manager.session.configuration.httpAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders[key] = value
            manager.session.configuration.httpAdditionalHeaders = sessionHeaders
        } else {
            manager.session.configuration.httpAdditionalHeaders = [
                key: value
            ]
        }

    }
    
    func removeSessionHeaderIfExists(key: String) {
        let manager = Alamofire.SessionManager.default
        if var sessionHeaders = manager.session.configuration.httpAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders.removeValue(forKey: key)
            manager.session.configuration.httpAdditionalHeaders = sessionHeaders
        }
    }
    
    func alamofireManager() -> SessionManager {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = AccessTokenAdapter(accessToken: self.OAuthToken!)
        return sessionManager
    }

    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    // MARK: - OAuth flow
    func startOAuth2Login() {
        let authPath:String = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=repo&state=TEST_STATE"
        if let authURL:URL = URL(string: authPath) {
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "loadingOAuthToken")
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        }
    }
    
    func processOAuthStep1Response(url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercased() == "code") {
                    code = queryItem.value
                    break
                }
            }
        }
        if let receivedCode = code {
            let getTokenPath:String = "https://github.com/login/oauth/access_token"
            let tokenParams = ["client_id": clientID, "client_secret": clientSecret, "code": receivedCode]
            Alamofire.request(getTokenPath, method: .get, parameters: tokenParams)
                .responseString { response in
                    switch response.result {
                        
                    case .success:
                        if let value = response.result.value {
                            let resultParams:[String] = value.components(separatedBy: "&")
                            for param in resultParams {
                                let resultsSplit = param.components(separatedBy: "=")
                                if resultsSplit.count == 2 {
                                    let key = resultsSplit[0].lowercased() // access_token, scope, token_type
                                    let value = resultsSplit[1]
                                    switch key {
                                    case "access_token":
                                        self.OAuthToken = value
                                        
                                    case "scope":
                                        // TODO: verify scope
                                        print("SET SCOPE")
                                    case "token_type":
                                        // TODO: verify is bearer
                                        print("CHECK IF BEARER")
                                    default:
                                        print("got more than I expected from the OAuth token exchange")
                                    }
                                }
                            }
                            print("token: \(resultParams)")
                        }
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "loadingOAuthToken")
                        if self.hasOAuthToken() {
                            if let completionHandler = self.oauthTokenCompletionHandler {
                                completionHandler(nil)
                            }
                        } else {
                            if let completionHandler = self.oauthTokenCompletionHandler {
                                let noOAuthError = NSError(domain: "AlamofireErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                                completionHandler(noOAuthError)
                            }
                        }

                    case .failure(let error):
                        print("Not working")
                        print(response.request as Any)
                        print(response)
                        print(response.data as Any)
                        print(error.localizedDescription)
                        print("Erreur: \(error.localizedDescription)")
                        if let completionHandler = self.oauthTokenCompletionHandler {
                            let noAuthError = NSError(domain: "AlamofireErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an Oauth code", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                           completionHandler(noAuthError)
                        }
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "loadingOAuthToken")
                    }
            }
        } else {
            // no code in URL that we launched with
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "loadingOAuthToken")
        }

    }
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://api.github.com/") {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
