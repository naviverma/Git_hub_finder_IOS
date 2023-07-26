
import XCTest
import UIKit
@testable import Github_user_ios

class ProfileViewControllerTests: XCTestCase {
    
    var profileViewController: MockProfileViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? MockProfileViewController
        XCTAssertNotNil(profileViewController, "ProfileViewController couldn't be instantiated.")
        profileViewController.usernamePassedBylogin = "naviverma"
        let _ = profileViewController.view
    }

    override func tearDown() {
        profileViewController = nil
        super.tearDown()
    }
    
    func testOutletsAreConnected() {
        XCTAssertNotNil(profileViewController.profileImage, "profileImage is nil.")
        XCTAssertNotNil(profileViewController.segmentController, "segmentController is nil.")
        XCTAssertNotNil(profileViewController.collectionView, "collectionView is nil.")
        XCTAssertNotNil(profileViewController.HeaderView, "HeaderView is nil.")
        XCTAssertNotNil(profileViewController.repoTable, "repoTable is nil.")
        XCTAssertNotNil(profileViewController.username, "username is nil.")
        XCTAssertNotNil(profileViewController.bio, "bio is nil.")
        XCTAssertNotNil(profileViewController.hashtag, "hashtag is nil.")
    }

    func testDataSourceIsSet() {
        XCTAssertNotNil(profileViewController.collectionView.dataSource, "CollectionView dataSource not set.")
        XCTAssertNotNil(profileViewController.repoTable.dataSource, "RepoTable dataSource not set.")
    }
    
    func testDelegateIsSet() {
        XCTAssertNotNil(profileViewController.collectionView.delegate, "CollectionView delegate not set.")
        XCTAssertNotNil(profileViewController.repoTable.delegate, "RepoTable delegate not set.")
    }
    
    func testRepoRowPressed() {
            let indexPath = IndexPath(row: 0, section: 0)
            profileViewController.tableView(profileViewController.repoTable, didSelectRowAt: indexPath)
            
            XCTAssertTrue(profileViewController.performSegueCalled)
            XCTAssertEqual(profileViewController.segueIdentifier, "profiletocontri")
        }
    
    func testFollowButtonPressed(){
        profileViewController.Follow(UIButton())
        
            XCTAssert(profileViewController.presentCalled)
            let alertController = profileViewController.Controller as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertEqual(alertController?.title, "FOLLOW")
            XCTAssertEqual(alertController?.message, "This feature is not available yet")
    }
}

class MockProfileViewController: ProfileViewController {
//    var spyController = SpyViewController()
    var presentCalled = false
    var Controller: UIViewController?
    var performSegueCalled:Bool = false
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
