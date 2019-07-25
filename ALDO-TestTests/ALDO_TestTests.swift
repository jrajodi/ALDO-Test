//
//  ALDO_TestTests.swift
//  ALDO-TestTests
//
//  Created by Jignesh Rajodiya on 2019-07-25.
//  Copyright © 2019 Jignesh Rajodiya. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import ALDO_Test

class ALDO_TestTests: XCTestCase {

    var reponseData: Data?
    
    override func setUp() {
        reponseData = try? TestUtils.jsonData(forResource: "repos-data")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoNullRepoModelData() {
        
        // Given repositories
        var repos = [Repo]()
        let json = try? JSON(data: reponseData!)
        
        for (key, jsonRepo) in try! JSON(data: reponseData!) {
            print(key)
            print(jsonRepo)
            let repo = Repo(json: jsonRepo)
            
            repos.append(repo)
        }
        
        if repos.isEmpty {
            XCTFail()
        }else{
            XCTAssertNotNil(repos)
        }
        
    }
    
    func testValiFirstdRepoModelData() {

        // Given repositories
        var repos = [Repo]()
    
        for (key, jsonRepo) in try! JSON(data: reponseData!) {
            print(key)
            print(jsonRepo)
            let repo = Repo(json: jsonRepo)
            
            repos.append(repo)
        }
        
        let repo: Repo = repos.first!
      
        // Then should have populated list of repositories
        XCTAssertNotNil(repo)
        XCTAssertEqual(repo.name, "spack")
        XCTAssertEqual(repo.description, "A flexible package manager that supports multiple versions, configurations, platforms, and compilers.")
        XCTAssertEqual(repo.avatarURL, "https://avatars1.githubusercontent.com/u/53232627?v=4")
        XCTAssertEqual(repo.type, "Fork")
        XCTAssertEqual(repo.url, "https://api.github.com/repos/rajodiyaj/spack")
    }

    func testValiLastdRepoModelData() {
        
        // Given repositories
        var repos = [Repo]()
        
        for (key, jsonRepo) in try! JSON(data: reponseData!) {
            print(key)
            print(jsonRepo)
            let repo = Repo(json: jsonRepo)
            
            repos.append(repo)
        }
        
        let repo: Repo = repos.last!
        
        // Then should have populated list of repositories
        XCTAssertNotNil(repo)
        XCTAssertEqual(repo.name, "test")
        XCTAssertEqual(repo.avatarURL, "https://avatars1.githubusercontent.com/u/53232627?v=4")
        XCTAssertEqual(repo.type, "Public")
        XCTAssertEqual(repo.url, "https://api.github.com/repos/rajodiyaj/test")
    }

}
