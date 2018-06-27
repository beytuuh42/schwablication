//
//  Category.swift
//  schwablication
//
//  Created by bi on 18.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

/// Enum class for the category entry in the database
enum Category : CustomStringConvertible {
    case Ausgaben
    case Einkommen
    
    var description : String {
        switch self {

        case .Ausgaben: return "Ausgaben"
        case .Einkommen: return "Einkommen"
        }
    }
}
