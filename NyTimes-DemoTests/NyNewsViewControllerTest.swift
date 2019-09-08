//
//  NyNewsViewControllerTest.swift
//  NyTimes-DemoTests
//
//  Created by Herock Hasan on 6/10/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import XCTest
@testable import NyTimes_Demo

class NyNewsViewControllerTest: XCTestCase {
    
    var viewControllerUnderTest: NyNewsViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "home") as! NyNewsViewController
        
        // in view controller, menuItems = ["one", "two", "three"]
        self.viewControllerUnderTest.loadView()
        self.viewControllerUnderTest.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasATableView() {
        XCTAssertNotNil(viewControllerUnderTest.newsTableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(viewControllerUnderTest.newsTableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(viewControllerUnderTest.newsTableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }
    
    func testTableCellHasCorrectLabelText() {
        let cell0 = viewControllerUnderTest.tableView(viewControllerUnderTest.newsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? NewsCell
        XCTAssertEqual(cell0?.newscategory.text, "science")
        
        let cell1 = viewControllerUnderTest.tableView(viewControllerUnderTest.newsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? NewsCell
        XCTAssertEqual(cell1?.newscategory.text, "Technology")
        
        let cell2 = viewControllerUnderTest.tableView(viewControllerUnderTest.newsTableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? NewsCell
        XCTAssertEqual(cell2?.newscategory.text, "Style")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
