//
//  ListViewUITest.swift
//  schwablicationUITests
//
//  Created by bi on 28.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class ListViewUITest: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
            
        // Running app and going to the list view
        app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["List"].tap()
    }
    
    func testScreenExists() {
        XCTAssertTrue(app.otherElements["listView"].exists)
    }
    
    func testToScreenExtended(){
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["extendedView"].exists)
    }
    
    func testSwipeToDelete(){
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        tablesQuery.element(boundBy: 0).buttons["Delete"].tap()
    }
}
