//
//  WelcomeScreenTests.swift
//  Who's Driving?!
//
//  Created by Josh Freed on 8/26/15.
//  Copyright © 2015 Josh Freed. All rights reserved.
//

import XCTest

class WelcomeScreenTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchArguments = ["RESET"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstRunShowsWelcomeScreen() {
        let app = XCUIApplication()
        XCTAssert(app.buttons["Who's Driving?!"].exists);
    }
    
}
