//
//  DateFormatterUnitTest.swift
//  schwablicationTests
//
//  Created by bi on 01.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest
@testable import Pods_schwablication

class DateFormatterUnitTest: XCTestCase {
    
    var formatter: DateFormatter?
    let timeinterval = 1530453161.573261
    
    override func setUp() {
        super.setUp()
        formatter = DateFormatter(ti: timeinterval)
    }

    func testFormattedDate(){
        let formatted = formatter?.getFormattedDate()
        let exptected = "01. Jan"
        XCTAssertEqual(formatted, exptected)
    }
}
