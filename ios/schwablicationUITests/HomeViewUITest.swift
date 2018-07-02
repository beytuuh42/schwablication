//
//  HomeViewUITest.swift
//  schwablicationUITests
//
//  Created by Ehsan Rajol on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class HomeViewUITest: XCTestCase {
    
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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Running app and performing login
        app = XCUIApplication()
        app.launch()
        performLogin()
        amountTextField = app.textFields["amountTextField"]
        titleTextField = app.textFields["titleTextField"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func performLogin() {
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
    }
    
    func testPerformAddEntryNoInputPlusButton(){
        app.buttons["+"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertTrue(okButton.exists)
    }
    
    func testPerformAddEntryNoInputMinusButton(){
        app.buttons["-"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertTrue(okButton.exists)
    }
    
    func testPerformAddEntrySemiInputPlusButton(){
        amountTextField.tap()
        amountTextField.typeText("65.50")
        app.buttons["+"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertTrue(okButton.exists)
    }
    
    func testPerformAddEntrySemiInputMinusButton(){
        amountTextField.tap()
        amountTextField.typeText("65.50")
        app.buttons["-"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertTrue(okButton.exists)
    }
    
    func testPerformAddEntryWithInputMinusButton(){
        amountTextField.tap()
        amountTextField.typeText("65.50")
        titleTextField.tap()
        titleTextField.typeText("Shopping")
        app.buttons["-"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertFalse(okButton.exists)
    }
    
    func testPerformAddEntryWithInputPlusButton(){
        amountTextField.tap()
        amountTextField.typeText("165.50")
        titleTextField.tap()
        titleTextField.typeText("Lohn")
        app.buttons["+"].tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        XCTAssertFalse(okButton.exists)
    }
}
