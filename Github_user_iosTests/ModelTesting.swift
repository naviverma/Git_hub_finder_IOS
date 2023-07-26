//
//  Github_user_iosTests.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 20/07/2023.
//

import XCTest
@testable import Github_user_ios

final class Github_user_iosTests: XCTestCase {
    
    //MARK: - Model checking
    
    func testStructCodableConformance(){
        let jsonForRepos = """
    {
        "name": "Test Repo",
        "description": "This is a test repository",
        "language": "Swift",
        "stargazers_count": 10,
        "forks_count": 5,
        "updated_at": "2023-07-19T12:34:56Z",
        "visibility": "public",
        "owner": {
            "avatar_url": "https://example.com/avatar.png"
    }
        
    }
""".data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let repo = try! decoder.decode(GitHubRepo.self,from: jsonForRepos)
        
        XCTAssertEqual(repo.name, "Test Repo")
        XCTAssertEqual(repo.description, "This is a test repository")
        XCTAssertEqual(repo.language, "Swift")
        XCTAssertEqual(repo.stargazersCount, 10)
        XCTAssertEqual(repo.forksCount, 5)
        XCTAssertEqual(repo.updatedAt, "2023-07-19T12:34:56Z")
        XCTAssertEqual(repo.visibility, "public")
        XCTAssertEqual(repo.owner?.avatarURL, "https://example.com/avatar.png")
        
        let jsonForContributors = """
        {
            "login": "testUser",
            "avatar_url": "https://example.com/avatar.png",
            "contributions": 42
        }
        """.data(using: .utf8)!
        
        let contri = try! decoder.decode(GitHubRepoContri.self, from: jsonForContributors)

        XCTAssertEqual(contri.login, "testUser")
        XCTAssertEqual(contri.avatarURL, "https://example.com/avatar.png")
        XCTAssertEqual(contri.contributions, 42)
        
        let jsonForUser = """
        {
            "login": "testUser",
            "name": "Test User",
            "bio": "A test user",
            "location": "Test City",
            "avatar_url": "https://example.com/avatar.png",
            "following": 10,
            "followers": 20,
            "public_repos": 5,
            "email": "test@example.com"
        }
        """.data(using: .utf8)!

        let user = try! decoder.decode(GitHubUser.self, from: jsonForUser)

        XCTAssertEqual(user.login, "testUser")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.bio, "A test user")
        XCTAssertEqual(user.location, "Test City")
        XCTAssertEqual(user.avatarURL, "https://example.com/avatar.png")
        XCTAssertEqual(user.following, 10)
        XCTAssertEqual(user.followers, 20)
        XCTAssertEqual(user.publicRepos, 5)
        XCTAssertEqual(user.email, "test@example.com")
        
        let jsonForFile = """
        {
            "name": "testFile",
            "path": "test/path"
        }
        """.data(using: .utf8)!
        
        let file = try! decoder.decode(GitRepoFiles.self, from: jsonForFile)

        XCTAssertEqual(file.name, "testFile")
        XCTAssertEqual(file.path, "test/path")
        
        let jsonForCode = """
        {
            "content": "testContent",
            "download_url": "https://example.com/download"
        }
        """.data(using: .utf8)!

        let code = try! decoder.decode(GitCode.self, from: jsonForCode)

        XCTAssertEqual(code.content, "testContent")
        XCTAssertEqual(code.downloadURL, "https://example.com/download")
        
    }
    
    func testForMissingFieldsInJson(){
        
        let jsonForRepos = """
    {
        "name": "Test Repo"
        
    }
""".data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let repo = try! decoder.decode(GitHubRepo.self,from: jsonForRepos)
        
        XCTAssertEqual(repo.name, "Test Repo") // This cant be nil
        XCTAssertNil(repo.description)
        XCTAssertNil(repo.language)
        XCTAssertNil(repo.forksCount)
        XCTAssertNil(repo.updatedAt)
        XCTAssertNil(repo.visibility)
        XCTAssertNil(repo.owner?.avatarURL)
        
        let jsonForContributors = """
        {
            "login": "testUser",
            
        }
        """.data(using: .utf8)!
        
        let contri = try! decoder.decode(GitHubRepoContri.self, from: jsonForContributors)

        XCTAssertEqual(contri.login, "testUser")
        XCTAssertNil(contri.avatarURL)
        XCTAssertNil(contri.contributions)
        
        let jsonForUser = """
        {
            "login": "testUser",
        }
        """.data(using: .utf8)!

        let user = try! decoder.decode(GitHubUser.self, from: jsonForUser)

        XCTAssertEqual(user.login, "testUser")//This cant be nil
        XCTAssertEqual(user.name, nil)//This is same as XTCAssertNil
        XCTAssertEqual(user.bio, nil)
        XCTAssertEqual(user.location, nil)
        XCTAssertEqual(user.avatarURL, nil)
        XCTAssertEqual(user.following, nil)
        XCTAssertEqual(user.followers, nil)
        XCTAssertEqual(user.publicRepos, nil)
        XCTAssertEqual(user.email, nil)
        
        let jsonForFile = """
        {
        }
        """.data(using: .utf8)!
        
        let file = try! decoder.decode(GitRepoFiles.self, from: jsonForFile)

        XCTAssertEqual(file.name, nil)//this is same as XCTAssertNil
        XCTAssertEqual(file.path, nil)
        
        let jsonForCode = """
        {
        }
        """.data(using: .utf8)!

        let code = try! decoder.decode(GitCode.self, from: jsonForCode)

        XCTAssertEqual(code.content, nil)//This is same as XCTAssertNil
        XCTAssertEqual(code.downloadURL, nil)
        
    }

}
