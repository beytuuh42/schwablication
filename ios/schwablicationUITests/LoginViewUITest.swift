//
//  LoginViewUITest.swift
//  schwablicationUITests
//
//  Created by bi on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class LoginViewUITest: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Running app and going to the list view
        app = XCUIApplication()
        app.launch()
    }
    
    func testScreenExists() {
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testPerformLogin(){
        let app = XCUIApplication()
        
        let emailTextField = app.textFields["emailTextField"]
        let passwordTextField = app.secureTextFields["passwordTextField"]
        let loginButton = app.buttons["loginButton"]


        emailTextField.tap()
        emailTextField.typeText("test@test.de")
        passwordTextField.tap()
        passwordTextField.typeText("testtest")
        
        loginButton.tap()
        app.alerts["Success"].buttons["OK"].tap()
        XCTAssertTrue(app.otherElements["homeView"].exists)
    }
    
    func testRegisterExists() {
        let registerButton = app.buttons["registerButton"]
        registerButton.tap()
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
}
