//
//  NYTimesAPITests.swift
//  NyTimes-DemoTests
//
//  Created by Herock Hasan on 6/10/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import XCTest
@testable import NyTimes_Demo

class NYTimesAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFeaturedAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "Fetch Json Start")
        
        NYTimesAPI.sharedInstance.fetchFeaturedArticles { (data, error) in
            XCTAssertNotNil(data, "No Data returned")
            XCTAssertNil(error, "Unexpected error occured: \(error?.localizedDescription)")
            
            expect.fulfill()
            
        }
        waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
    }
    
    func testSearchAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "Fetch Json Start")
        
        NYTimesAPI.sharedInstance.searchArticles(query: "trump", completion: { (data, error) in
            
            XCTAssertNotNil(data, "No Data returned")
            XCTAssertNil(error, "Unexpected error occured: \(error?.localizedDescription)")
            expect.fulfill()
        })
     
        waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Test timed out. \(String(describing: error?.localizedDescription))")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
