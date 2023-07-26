//
//  APIHandlerTests.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 23/07/2023.
//

import XCTest
@testable import Github_user_ios

final class APIHandlerTests: XCTestCase {

    var apiHandling:ApiHandling!
    
    override func setUp() {
        super.setUp()
        apiHandling = ApiHandling()
    }
    override func tearDown() {
        apiHandling = nil
        super.tearDown()
    }
    
    func testFetchUser() {
        let expectation = self.expectation(description: "FetchUser")

        ApiHandling.fetchUser(username: "naviverma") { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
            
            // Now check that the user has the expected username and other properties
            XCTAssertEqual(result?.login, "naviverma")
            XCTAssertEqual(result?.name, "Navdeep Singh")
            XCTAssertEqual(result?.bio, "Jinggggggg!!!")
            XCTAssertNil(result?.location)
            XCTAssertEqual(result?.avatarURL, "https://avatars.githubusercontent.com/u/71190233?v=4")
            XCTAssertEqual(result?.following, 0)
            XCTAssertEqual(result?.followers, 0)
            XCTAssertEqual(result?.publicRepos, 10)
            XCTAssertNil(result?.email)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    
    func testFetchUserForNoUser() {
        let expectation = expectation(description: "UserNotFetched")
        ApiHandling.fetchUser(username: "lkdshflsjahdflkjahsl"){//lkdshflsjahdflkjahsl is random username that dont exist
            (result,error) in
            XCTAssertNotNil(error)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation],timeout: 5)
    }
    
    func testFetchUserRepo() {
            let expectation = self.expectation(description: "FetchUserRepo")

            ApiHandling.fetchUserRepo(username: "naviverma") { (result, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                
                XCTAssertEqual(result?.count, 10)
                
                //and data verification for first repo
                let repo = result?.first
                XCTAssertEqual(repo?.name, "c-programming")
                XCTAssertEqual(repo?.description, "in this we are making two games with the help of c programming")
                XCTAssertEqual(repo?.language, nil) // Based on the JSON response, the language property is null
                XCTAssertEqual(repo?.stargazersCount, 1)
                XCTAssertEqual(repo?.forksCount, 0)
                XCTAssertEqual(repo?.updatedAt, "2023-07-13T15:04:47Z")
                XCTAssertEqual(repo?.visibility, "public")
                XCTAssertNotNil(repo?.owner)
                expectation.fulfill()
            }

            wait(for: [expectation],timeout: 5)
        }

        func testFetchContributors() {
            let expectation = self.expectation(description: "FetchContributors")

            ApiHandling.fetchContributors(username: "naviverma", repoName: "c-programming") { (result, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                let contributor = result?.first
                XCTAssertEqual(contributor?.login, "naviverma")
                XCTAssertEqual(contributor?.avatarURL, "https://avatars.githubusercontent.com/u/71190233?v=4")
                XCTAssertEqual(contributor?.contributions, 5)
                expectation.fulfill()
            }

            wait(for: [expectation],timeout: 5)
        }

        func testFetchRepoFiles() {
            let expectation = self.expectation(description: "FetchRepoFiles")

            ApiHandling.fetchRepoFiles(username: "naviverma", repoName: "c-programming", additional: nil) { (result, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                expectation.fulfill()
            }

            wait(for: [expectation],timeout: 5)
        }

        func testFetchCode() {
            let expectation = self.expectation(description: "FetchCode")

            ApiHandling.fetchCode(username: "naviverma", repoName: "c-programming", additional: "README.md") { (result, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(result)
                expectation.fulfill()
            }

            wait(for: [expectation],timeout: 5)
        }
}
