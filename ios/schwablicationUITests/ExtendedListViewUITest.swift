//
//  ExtendedListViewUITest.swift
//  schwablicationUITests
//
//  Created by Memo on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class ExtendedListViewUITest: XCTestCase {
    
    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var registerButton: XCUIElement!
    var descriptionTextField: XCUIElement!
    let descriptions = "Testing"
    let email = "test@test.de"
    let pass = "testtest"
    var amountTextField: XCUIElement!
    var titleTextField: XCUIElement!
    
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Running app and performing login
        
        app = XCUIApplication()
        app.launch()
        performLogin()
    }
    
    func testScreenExists() {
        navigateToExtended()
        XCTAssertTrue(app.otherElements["extendedView"].exists)
    }
    func testSaveButton() {
        navigateToExtended()
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.otherElements["listView"].exists)
    }
    
    func testDescriptionField() {
        navigateToExtended()
        descriptionTextField = app.textFields["descriptionTextField"]
        descriptionTextField.tap()
        descriptionTextField.typeText(descriptions)
        descriptionTextField.tap()
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()
        descriptionTextField.typeText(descriptions)
        app.buttons["saveButton"].tap()
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).tap()
        XCTAssertEqual(descriptionTextField.value as! String, descriptions)
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
    
    func navigateToExtended(){
        app.tabBars.buttons["List"].tap()
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).tap()
    }
}
