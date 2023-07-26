//
//  ControllerTestingForContributors.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 25/07/2023.
//

import XCTest
@testable import Github_user_ios

final class ControllerTestingForContributors: XCTestCase {
    
    var controller: MockContributorsViewController!
    var storyBoard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier:"ContributorsViewController") as? MockContributorsViewController
        controller.usernamePassedByContri = "naviverma"
        controller.repoNamePassedByContri = "c-programming"
        let _ = controller.view
    }
    
    override func tearDown() {
        controller = nil
        storyBoard = nil
        super.tearDown()
    }
    
    func testOutletsAreConnected() {
            XCTAssertNotNil(controller.contriHeader, "contriHeader is nil.")
            XCTAssertNotNil(controller.contriTable, "contriTable is nil.")
            XCTAssertNotNil(controller.segmentControllerFiles, "segmentControllerFiles is nil.")
            XCTAssertNotNil(controller.codeBaseHeader, "codeBaseHeader is nil.")
        }
    func testDataSourceIsSet() {
        XCTAssertNotNil(controller.contriTable.dataSource, "RepoTable dataSource not set.")
    }
    
    func testDelegateIsSet() {
        XCTAssertNotNil(controller.contriTable.delegate, "RepoTable dataSource not set.")
    }
    
    func testRepoRowPressedForProfile() {
        controller.segmentControllerFiles.selectedSegmentIndex = 0
            let indexPath = IndexPath(row: 0, section: 0)
            controller.tableView(controller.contriTable, didSelectRowAt: indexPath)
        if controller.segmentControllerFiles.selectedSegmentIndex == 0{
            XCTAssertTrue(controller.performSegueCalled)
            XCTAssertEqual(controller.segueIdentifier, "contritoprofile")
        }
        else{
            XCTAssertTrue(controller.performSegueCalled)
            XCTAssertEqual(controller.segueIdentifier, "contritofile")
        }
        }
    
    func testRepoRowPressedForFiles() {
        controller.segmentControllerFiles.selectedSegmentIndex = 1
            let indexPath = IndexPath(row: 0, section: 0)
            controller.tableView(controller.contriTable, didSelectRowAt: indexPath)
        if controller.segmentControllerFiles.selectedSegmentIndex == 0{
            XCTAssertTrue(controller.performSegueCalled)
            XCTAssertEqual(controller.segueIdentifier, "contritoprofile")
        }
        else{
            XCTAssertTrue(controller.performSegueCalled)
            XCTAssertEqual(controller.segueIdentifier, "contritofile")
        }
        }
    
}

class MockContributorsViewController: ContributorsViewController {
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
