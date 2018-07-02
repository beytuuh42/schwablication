//
//  DbConstantsUnitTest.swift
//  schwablicationTests
//
//  Created by bi on 02.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class DbConstantsUnitTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testColumnId(){
        XCTAssertEqual(DbConstants.columnId.description, "id")
    }
    
    func testColumnAmount(){
        XCTAssertEqual(DbConstants.columnAmount.description, "amount")
    }
    
    func testColumnTitle(){
        XCTAssertEqual(DbConstants.columnTitle.description, "title")
    }
    
    func testColumnDescription(){
        XCTAssertEqual(DbConstants.columnDescription.description, "description")
    }
    
    func testColumnPhoto(){
        XCTAssertEqual(DbConstants.columnPhoto.description, "photo")
    }
    
    func testColumnCategory(){
        XCTAssertEqual(DbConstants.columnCategory.description, "category")
    }
    
    func testColumnCreatedAt(){
        XCTAssertEqual(DbConstants.columnCreatedAt.description, "created_at")
    }
}
