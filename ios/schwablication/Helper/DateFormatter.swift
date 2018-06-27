//
//  DateFormatter.swift
//  schwablication
//
//  Created by bi on 23.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation

/// Helper class for formatting the date into a read-able String
class DateFormatter {
    
    var myTimeInterval:Double
    
    init(ti : Double){
        self.myTimeInterval = ti
    }
    
    
    /// This method is formatting the given date value from timeinterval into a readable date format (e.g. 22. Juni)
    ///
    /// - Returns: formatted date value as a String
    
    func getFormattedDate() -> String{
        let myTimeInterval = TimeInterval(self.myTimeInterval)
        let unformattedDate =  NSDate(timeIntervalSince1970: myTimeInterval).description
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-DD HH:mm:ss Z"
        let convertedDate = dateFormatter.date(from: unformattedDate)
        
        guard dateFormatter.date(from: unformattedDate) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd. MMM"
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
}
