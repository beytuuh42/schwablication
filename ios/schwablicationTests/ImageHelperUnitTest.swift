//
//  ImageHelperUnitTest.swift
//  schwablicationTests
//
//  Created by bi on 02.07.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import XCTest

class ImageHelperUnitTest: XCTestCase {
    
    var helper:ImageHelper?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        helper = ImageHelper()
    }
    
    func testImageSize(){
        let size = CGSize(width:150.0, height:150.0)
        let orgImage = UIImage.gif(asset: "loading")
        let resizedImage = helper?.resizeImage(image: orgImage!, targetSize: size)

        XCTAssertEqual(resizedImage?.size, size)
    }
    
}
