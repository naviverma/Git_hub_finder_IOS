//
//  ControllerTestingForRepo.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 25/07/2023.
//

import XCTest
@testable import Github_user_ios

final class ControllerTestingForRepo: XCTestCase {
    
    var controller: MockRepoViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier:"RepoViewController") as? MockRepoViewController
        controller.usernamePassed = "naviverma"
        controller.reponamePassed = "Git_hub_finder_IOS"
        let _ = controller.view
    }
    
    override func tearDown() {
        controller = nil
        super.tearDown()
    }
    
    func testOutletsAreConnected() {
        XCTAssertNotNil(controller.fileImage, "fileImage is nil.")
        XCTAssertNotNil(controller.ImageVIewHeader, "ImageVIewHeader is nil.")
        XCTAssertNotNil(controller.normalHeader, "normalHeader is nil.")
        XCTAssertNotNil(controller.textViewEditor, "textViewEditor is nil.")
        XCTAssertNotNil(controller.filetable, "filetable is nil.")
        XCTAssertNotNil(controller.textView, "textView is nil.")
    }
    func testDataSourceIsSet() {

        XCTAssertNotNil(controller.filetable.dataSource, "RepoTable dataSource not set.")
    }
    
    func testDelegateIsSet() {
        
        XCTAssertNotNil(controller.filetable.delegate, "RepoTable delegate not set.")
    }
    
    func testFileRowPressed() {
        for index in 0...3{
            let indexPath = IndexPath(row: index, section: 0)
            controller.performSegueCalled = false
            controller.segueIdentifier = ""
            controller.tableView(controller.filetable, didSelectRowAt: indexPath)
            XCTAssertTrue(controller.performSegueCalled)
            XCTAssertEqual(controller.segueIdentifier, "filetofile")
        }
            
        }
    
}

class MockRepoViewController: RepoViewController {
    var presentCalled = false
    var Controller: UIViewController?
    var performSegueCalled:Bool = true
    var segueIdentifier:String = ""
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
        Controller = viewControllerToPresent
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        performSegueCalled = true
        segueIdentifier = identifier
    }
}
