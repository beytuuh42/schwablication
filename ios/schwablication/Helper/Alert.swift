//
//  Alert.swift
//  schwablication
//
//  Created by Ehsan Rajol on 25.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    
    // alert function for error messages
    class func showBasic(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    
    
    
}
