//
//  ListViewUITest.swift
//  schwablicationUITests
//
//  Created by bi on 28.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class ListViewUITest: XCTestCase {
    
    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var registerButton: XCUIElement!
    let email = "test@test.de"
    let pass = "testtest"
    var amountTextField: XCUIElement!
    var titleTextField: XCUIElement!
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
            
        // Running app and going to the list view
        app = XCUIApplication()
        app.launch()
        performLogin()
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
        while(tablesQuery.count > 0){
            tablesQuery.element(boundBy: 0).swipeLeft()
            tablesQuery.element(boundBy: 0).buttons["Delete"].tap()
        }
        XCTAssertEqual(tablesQuery.count, 0)
    }
    
    func performLogin(){
        emailTextField = app.textFields["emailTextField"]
        passwordTextField = app.secureTextFields["passwordTextField"]
        loginButton = app.buttons["loginButton"]
        registerButton = app.buttons["registerButton"]
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordTextField.tap()
        passwordTextField.typeText(pass)
        loginButton.tap()
        app.alerts["Success"].buttons["OK"].tap()
        performAddEntry()
    }
    
    func performAddEntry(){
        amountTextField = app.textFields["amountTextField"]
        titleTextField = app.textFields["titleTextField"]
        amountTextField.tap()
        amountTextField.typeText("165.50")
        titleTextField.tap()
        titleTextField.typeText("Lohn")
        app.buttons["+"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertFalse(okButton.exists)
    }
}
