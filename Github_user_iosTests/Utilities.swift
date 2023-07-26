//
//  Download.swift
//  Github_user_iosTests
//
//  Created by Navdeep on 23/07/2023.
//

import XCTest
@testable import Github_user_ios

class DownloadTestsandOtherUtilities: XCTestCase {
    
    var download: Download!
    var dateFormatter: DateFormatterExplicit!

    override func setUp() {
        super.setUp()
        download = Download()
        dateFormatter = DateFormatterExplicit()
    }
    
    override func tearDown() {
        download = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    func testDownloadImage() {
        let expectation = self.expectation(description: "Download Image")
        
        let testURL = "https://picsum.photos/id/237/200/300"

        download.downloadImage(from: testURL) { (data) in
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
        }

        wait(for: [expectation],timeout: 5)
    }

    func testDownloadImageWithIndex() {
        let expectation = self.expectation(description: "Download Image With Index")
        
        let testURL = "https://picsum.photos/id/237/200/300"
        let testIndexPath = IndexPath(row: 0, section: 0)
        
        download.downloadImage(from: testURL, indexi: testIndexPath) { (data) in
            XCTAssertNotNil(data, "No data was downloaded.")
            expectation.fulfill()
        }

        wait(for: [expectation],timeout: 5)
    }
        
    func testYearsAgo() {
            let dateString = "2021-07-23T07:22:54Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "2 years ago")
        }

        func testMonthsAgo() {
            let dateString = "2023-06-23T07:22:54Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "1 month ago")
        }

        func testWeeksAgo() {
            let dateString = "2023-07-10T07:22:54Z"
            let currentDate = "2023-07-24T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "2 weeks ago")
        }

        func testDaysAgo() {
            let dateString = "2023-07-21T07:22:54Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "2 days ago")
        }

        func testHoursAgo() {
            let dateString = "2023-07-23T05:22:54Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "2 hours ago")
        }

        func testMinutesAgo() {
            let dateString = "2023-07-23T07:20:54Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "2 mins ago")
        }

        func testSecondsAgo() {
            let dateString = "2023-07-23T07:22:51Z"
            let currentDate = "2023-07-23T07:22:54Z"
            XCTAssertEqual(DateFormatterExplicit.formatedDate(dateString, _from: currentDate), "3 secs ago")
        }
    
    func testRoundOffValueLessThan1000() {
            let value = 500
            let result = RoundOff.roundoff(value)
            XCTAssertEqual(result, "500")
        }
        
        func testRoundOffValueMoreThan1000() {
            let value = 1500
            let result = RoundOff.roundoff(value)
            XCTAssertEqual(result, "1.5K")
        }
        
        func testRoundOffValueMoreThan1000000() {
            let value = 1500000
            let result = RoundOff.roundoff(value)
            XCTAssertEqual(result, "1.5M")
        }
        
        func testRoundOffValueExactly1000() {
            let value = 1000
            let result = RoundOff.roundoff(value)
            XCTAssertEqual(result, "1.0K")
        }
        
        func testRoundOffValueExactly1000000() {
            let value = 1000000
            let result = RoundOff.roundoff(value)
            XCTAssertEqual(result, "1.0M")
        }
}

