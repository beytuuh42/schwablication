//
//  CategoryUnitTest.swift
//  schwablicationTests
//
//  Created by bi on 02.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class CategoryUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAusgabenString(){
        XCTAssertEqual(Category.Ausgaben.description, "Ausgaben")
    }
    
    func testEinkommenString(){
        XCTAssertEqual(Category.Einkommen.description, "Einkommen")
    }
}
