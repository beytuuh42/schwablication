//
//  EntryModel.swift
//
//
//  Created by bi on 18.06.18.
//

import Firebase




public class EntryModel{
    
    /// Referencing to our firebase database child 'entries'
    var refEntries: DatabaseReference = Database.database().reference().child("entries")
    
    let id: String
    let title: String
    var desc: String = ""
    let amount: Double
    let createdAt: Double
    var photo: String = ""
    let category: String
    
    
    /// Converting the entry data into a read-able String
    public var description: String { return "Entry: id: \(id), title: \(title), desc: \(desc), amount: \(amount), createdAt: \(createdAt), category: \(category)," }
    
    /// Initializing an Entry Object for the list view
    init(id:String, title:String, amount: Double, createdAt: Double, category: String){
        self.id = id
        self.title = title
        self.amount = amount
        self.createdAt = createdAt
        self.category = category
    }
    
    /// Initializing an Entry Object for the extended view
    init(id:String, title:String, desc: String, amount: Double, createdAt: Double, photo: String, category: String){
        self.id = id
        self.title = title
        self.desc = desc
        self.amount = amount
        self.createdAt = createdAt
        self.photo = photo
        self.category = category
    }
    
    
    /// Column names for the database
    public struct DbColumns{
        static let columnId = "id"
        static let columnTitle = "title"
        static let columnDescription = "description"
        static let columnAmount = "amount"
        static let columnCategory = "category"
        static let columnCreatedAt = "created_at"
        static let columnPhoto = "photo"
    }
    
}
