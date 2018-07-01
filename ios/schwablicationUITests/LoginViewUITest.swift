//
//  LoginViewUITest.swift
//  schwablicationUITests
//
//  Created by bi on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class LoginViewUITest: XCTestCase {
    
    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var registerButton: XCUIElement!
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
        
        emailTextField = app.textFields["emailTextField"]
        passwordTextField = app.secureTextFields["passwordTextField"]
        loginButton = app.buttons["loginButton"]
        registerButton = app.buttons["registerButton"]
    }
    
    func testScreenExists() {
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testPerformLogin(){
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordTextField.tap()
        passwordTextField.typeText(pass)
        
        loginButton.tap()
        app.alerts["Success"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["homeView"].exists)
    }
    
    func testPerformLoginWrongCredentials(){
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordTextField.tap()
        passwordTextField.typeText("test")
        
        loginButton.tap()
        app.alerts["Error login"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testPerformLoginNoInput(){
        loginButton.tap()
        app.alerts["Incomplete Form"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testRegisterExists() {
        registerButton.tap()
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
}
