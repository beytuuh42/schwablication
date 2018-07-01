//
//  RegisterViewUITest.swift
//  schwablicationUITests
//
//  Created by bi on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class RegisterViewUITest: XCTestCase {
        
    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var createAccountButton: XCUIElement!
    let email = "test@test.de"
    let pass = "testtest"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Running app and going to the list view
        app = XCUIApplication()
        app.launch()
        app.buttons["registerButton"].tap()
        
        emailTextField = app.textFields["emailTextField"]
        passwordTextField = app.secureTextFields["passwordTextField"]
        createAccountButton = app.buttons["createAccountButton"]
    }
    
    func testScreenExists() {
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
    
    func testPerformRegister(){
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordTextField.tap()
        passwordTextField.typeText(pass)
        
        createAccountButton.tap()
        app.alerts["Success"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testPerformRegisterExistingCredentials(){
        emailTextField.tap()
        emailTextField.typeText("test@test.de")
        passwordTextField.tap()
        passwordTextField.typeText("test")
        
        createAccountButton.tap()
        app.alerts["Error creating account"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
    
    func testPerformLoginNoInput(){
        createAccountButton.tap()
        app.alerts["Incomplete Form"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
}
