//
//  EntryManager.swift
//  schwablication
//
//  Created by bi on 22.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Firebase

class EntryManager{
    
    var refEntries:DatabaseReference
    var entriesList = [EntryModel]()
    var totalSum:Double = 0.0
    var incSum:Double = 0.0
    var outSum:Double = 0.0
    
    
    /// Getting database reference
    ///
    /// - Parameter refEntries: database reference object
    init(refEntries:DatabaseReference){
        self.refEntries = refEntries
    }
    
    
    /// Adding a new entry to the database.
    /// Using the params to fill and an auto generated ID.
    /// - Parameters:
    ///   - title: title of the entry - String
    ///   - amount: amount of the entry - Double
    ///   - category: title of the entry - String
    func addEntry(title:String, amount:Double, category:String){
        let id = self.refEntries.childByAutoId().key
        let entry = [
            EntryModel.DbColumns.columnId:id as String,
            EntryModel.DbColumns.columnAmount:amount as Double,
            EntryModel.DbColumns.columnTitle:title as String,
            EntryModel.DbColumns.columnCreatedAt:NSDate().timeIntervalSince1970 as Double,
            EntryModel.DbColumns.columnCategory:category as String
            ] as [String : Any]
        self.refEntries.child(id).setValue(entry)
    }
    
    
    
    /// Fetching all entries from the datebase and saving into
    /// an EntryModel array.
    /// Using a closure to return the value after using the database.
    /// - Parameter completion: closure handler
    /// - return: returns an array wi
    func fetchAllData(completion: @escaping ([EntryModel]?)->()){
        self.entriesList.removeAll()
        self.refEntries.keepSynced(true)
        self.refEntries.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // check if there are entries
            if snapshot.childrenCount < 0 {
                completion(nil)
            }
            
            // iterating through all entries, saving them as a EntryModel object
            // and pushing it into the EntryModel array
            let enumerator = snapshot.children
            while let entries = enumerator.nextObject() as? DataSnapshot{
                let entryDic = entries.value as? NSDictionary
                
                let id = entryDic![EntryModel.DbColumns.columnId] as! String
                let title = entryDic![EntryModel.DbColumns.columnTitle] as! String
                let amount = entryDic![EntryModel.DbColumns.columnAmount] as! Double
                let category = entryDic![EntryModel.DbColumns.columnCategory] as! String
                let createdAt = entryDic![EntryModel.DbColumns.columnCreatedAt] as! Double
                
                let entry = EntryModel(id: id, title: title, amount: amount, createdAt: createdAt, category: category)
                self.entriesList.append(entry)
            }
            completion(self.entriesList)
        })
    }
    
    
    /// Returns an entry from the database by the given id.
    /// Using a closure to return the value after using the database.
    /// - Parameters:
    ///   - id: id of the entry
    ///   - completion: completion handler

    func getEntryBdId(id:String,completion: @escaping (EntryModel?)->()){
        self.refEntries.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // checking if an entry was found
            // on success creating an EntryModel with the data from the db
            
            if snapshot.childrenCount > 0 {
                let snap = snapshot.value as? NSDictionary

                let id = snap![EntryModel.DbColumns.columnId] as? String ?? ""
                let title = snap![EntryModel.DbColumns.columnTitle] as? String ?? ""
                let amount = snap![EntryModel.DbColumns.columnAmount] as? Double ?? 0
                let category = snap![EntryModel.DbColumns.columnCategory] as? String ?? ""
                let createdAt = snap![EntryModel.DbColumns.columnCreatedAt] as? Double ?? 0

                let desc = snap![EntryModel.DbColumns.columnDescription] as? String ?? ""
                let photo = snap![EntryModel.DbColumns.columnPhoto] as? String ?? ""
                
                let entry = EntryModel(id: id, title: title, desc: desc, amount: amount, createdAt: createdAt, photo: photo, category: category)
                completion(entry)
            }
        })
        completion(nil)
    }
    
    
    /// Delete entry by ID from firebase and by index from arraylist.
    ///
    /// - Parameters:
    ///   - id: id of the entry
    ///   - index: index in array
    func deleteEntryById(id:String, index:Int){
        self.refEntries.child(id).removeValue()
        self.entriesList.remove(at: index)
    }
    
    /// Fetching all entries from the datebase and saving into
    /// an EntryModel array.
    /// Using a closure to return the value after using the database.
    /// - Parameter completion: closure handler
    /// - return: returns an array wi
    func fetchTotalAmount(completion: @escaping (Double?)->()){
        self.totalSum = 0
        self.refEntries.keepSynced(true)
        self.refEntries.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // check if there are entries
            if snapshot.childrenCount < 0 {
                completion(nil)
            }
            
            // iterating through all entries, saving them as a EntryModel object
            // and pushing it into the EntryModel array
            let enumerator = snapshot.children
            while let entries = enumerator.nextObject() as? DataSnapshot{
                let entryDic = entries.value as? NSDictionary
                let amount = entryDic![EntryModel.DbColumns.columnAmount] as! Double
                
                self.totalSum += amount
            }
            completion(self.totalSum)
        })
    }
    
    /// Fetching all entries for the amount from the datebase and
    /// and saving into variables depending on the category String.
    /// Using a closure to return the value after using the database.
    /// - Parameters:
    ///   - category: String of the category
    ///   - completion: completion handler
    /// - return: sum value
    func fetchInOutAmount(category:String, completion: @escaping (Double?)->()){
        self.outSum = 0
        self.incSum = 0
        self.refEntries.keepSynced(true)
        self.refEntries.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // check if there are entries
            if snapshot.childrenCount < 0 {
                completion(nil)
            }
            
            // iterating through all entries, saving them as a EntryModel object
            // and pushing it into the EntryModel array
            let enumerator = snapshot.children
            while let entries = enumerator.nextObject() as? DataSnapshot{
                let entryDic = entries.value as? NSDictionary
                let amount = entryDic![EntryModel.DbColumns.columnAmount] as! Double
                let category = entryDic![EntryModel.DbColumns.columnCategory] as! String
                
                if(category == Category.Ausgaben.description){
                    self.outSum += amount
                } else {
                    self.incSum += amount
                }
            }
            if(category == Category.Einkommen.description){
                completion(self.incSum)
            } else {
                completion(self.outSum)
            }
        })
    }
    
    func updateEntryById(id:String, entry:EntryModel){
        let entryRef = refEntries.child("id/\(id)")
        let entryVal = [
            EntryModel.DbColumns.columnId:entry.id,
            EntryModel.DbColumns.columnAmount:entry.amount,
            EntryModel.DbColumns.columnTitle:entry.title,
            EntryModel.DbColumns.columnCreatedAt:entry.title,
            EntryModel.DbColumns.columnCategory:entry.category,
            EntryModel.DbColumns.columnDescription:entry.desc
            ] as [String : Any]
        entryRef.updateChildValues(entryVal)
    }
    
    
    /// Returns an array consisting of entries.
    ///
    /// - Returns: Entrymodel array
    func getEntriesList() -> [EntryModel]{
        return self.entriesList
    }
    
    /// Returns a double consisting of the total summed amount.
    ///
    /// - Returns: Entrymodel array
    func getTotalAmount() -> Double {
        return self.totalSum
    }
    
    /// Returns a double consisting of the incoming summed amount.
    ///
    /// - Returns: Entrymodel array
    func getTotalIncAmount() -> Double {
        return self.incSum
    }
    
    /// Returns a double consisting of the outgoing summed amount.
    ///
    /// - Returns: Entrymodel array
    func getTotalOutAmount() -> Double {
        return self.outSum
    }
}
