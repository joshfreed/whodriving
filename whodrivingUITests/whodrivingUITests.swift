//
//  whodrivingUITests.swift
//  whodrivingUITests
//
//  Created by Josh Freed on 8/26/15.
//  Copyright © 2015 Josh Freed. All rights reserved.
//

import XCTest

class whodrivingUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["RESET", "SKIP_WELCOME"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPersonCountStartsAtSix() {
        let app = XCUIApplication()
        XCTAssertEqual("6", app.staticTexts["PersonCount"].label)
    }
    
    func testPlusAndMinusButtonsChangePersonCount() {
        let app = XCUIApplication()

        app.buttons["PurplePlusButton"].tap()
        XCTAssertEqual("7", app.staticTexts["PersonCount"].label)
        
        app.buttons["PurplePlusButton"].tap()
        XCTAssertEqual("8", app.staticTexts["PersonCount"].label)
        
        app.buttons["PurpleMinusButton"].tap()
        XCTAssertEqual("7", app.staticTexts["PersonCount"].label)
        
        app.buttons["PurpleMinusButton"].tap()
        XCTAssertEqual("6", app.staticTexts["PersonCount"].label)
    }
    
}
