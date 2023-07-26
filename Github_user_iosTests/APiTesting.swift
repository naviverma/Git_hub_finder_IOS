//
//  APiTesting.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 20/07/2023.
//

import XCTest
@testable import Github_user_ios

final class APiTesting: XCTestCase {
    
    var apiManager:ApiManager!
    
    override func setUp(){
        super.setUp()
        apiManager = ApiManager()//instance of api manager
    }
    override func tearDown() {
        apiManager = nil
        super.tearDown()//this is called after cleanup code because if we call this before cleanup code it might interfere in the cleanup code and can lead to diff behaviour
    }
    
    func testApiCallCompletesWithoutErrors(){
        let condition = expectation(description: "Status code:200")//you can write anything in the description it is just for dev to understand what is this for
        
        apiManager.hitApi("https://www.google.com"){
            (data,error,errorMessage) in
            if error != nil {
                XCTFail()
                return
            }
            if errorMessage != nil{
                XCTFail()
                return
            }
            
            condition.fulfill()
        }
        wait(for: [condition],timeout: 5)
        
    }
}
