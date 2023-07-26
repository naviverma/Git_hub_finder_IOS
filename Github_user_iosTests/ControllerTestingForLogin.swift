//
//  ControllerTestingForLogin.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 24/07/2023.
//

import XCTest
@testable import Github_user_ios

final class ControllerTestingForLogin: XCTestCase {
    
    var controller: MockLoginViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier:"LoginViewController") as? MockLoginViewController
        let _ = controller.view
    }
    
    override func tearDown() {
        controller = nil
        storyBoard = nil
        super.tearDown()
    }
    
    func testOutletsAreConnected() {
            XCTAssertNotNil(controller.field, "field is nil.")
            XCTAssertNotNil(controller.loginTableForScrolling, "loginTableForScrolling is nil.")
            XCTAssertNotNil(controller.LoginHeaderView, "LoginHeaderView is nil.")
        }
    
    func testFindPressedWithEmptyFieldShouldShowAlert() {
            controller.field.text = ""
            controller.findPressed(UIButton())
            XCTAssert(controller.presentCalled)
            let alertController = controller.Controller as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertEqual(alertController?.title, "Error")
            XCTAssertEqual(alertController?.message, "Enter any username")
        }
    
    func testFindPressedWithWrongName(){
        let expectation = self.expectation(description: "Alert presented")
        controller.field.text = "non_existent_user_1234567890abcdef"
        controller.findPressed(UIButton())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssert(self.controller.presentCalled)
            let alertController = self.controller.Controller as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertEqual(alertController?.title, "Error")
            XCTAssertEqual(alertController?.message, "USERNAME NOT FOUND")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFindPressedWithCorrectName() {
        let expectation = self.expectation(description: "ProfileView presented")
        controller.field.text = "naviverma"
        controller.findPressed(UIButton())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssert(self.controller.performSegueCalled)
            XCTAssertEqual(self.controller.segueIdentifier, "logintoprofile")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

//class SpyViewController: UIViewController {
//    var presentCalled = false
//    var alertController: UIAlertController?
//
//    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        presentCalled = true
//        alertController = viewControllerToPresent as? UIAlertController
//        super.present(viewControllerToPresent, animated: flag, completion: completion)
//    }
//}

class MockLoginViewController: LoginViewController {
//    var spyController = SpyViewController()
    var presentCalled = false
    var Controller: UIViewController?
    var performSegueCalled:Bool = true
    var segueIdentifier:String = ""
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
//        spyController.present(viewControllerToPresent, animated: flag, completion: completion)
        presentCalled = true
        Controller = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
            performSegueCalled = true
            segueIdentifier = identifier
        }
}
