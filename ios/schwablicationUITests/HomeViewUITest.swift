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
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Running app and performing login
        app = XCUIApplication()
        app.launch()
        performLogin()
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
    
    func testAddButton(){
        
        app/*@START_MENU_TOKEN@*/.buttons["+"]/*[[".otherElements[\"homeView\"].buttons[\"+\"]",".buttons[\"+\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Incomplete Form"].buttons["OK"].tap()
        
    }
    
    func testMinusButton(){
        
        app/*@START_MENU_TOKEN@*/.buttons["-"]/*[[".otherElements[\"homeView\"].buttons[\"-\"]",".buttons[\"-\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let okButton = app.alerts["Incomplete Form"].buttons["OK"]
        okButton.tap()
        XCTAssertTrue(okButton.exists)
        
    }
}
