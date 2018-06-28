//
//  ViewController.swift
//  schwablication
//
//  Created by bi on 18.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblEntries: UITableView!
    var refEntries: DatabaseReference!
    var entryManager:EntryManager?

    
    /// Loading the application.
    /// Declaring the references for our database and model manager class.
    /// Loading data into the view
    override func viewDidLoad() {
        super.viewDidLoad()

        refEntries = Database.database().reference().child("entries")
        entryManager = EntryManager(refEntries: self.refEntries)
        
//        entryManager!.addEntry(title: "H&M Einkauf", amount: 100,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             category: Category.Ausgaben.description)
        refreshTable()
    }
    
    
    /// After completion of fetching, reloading the table for the view
    func refreshTable(){
        entryManager?.fetchAllData(completion: { entry in
            if entry != nil {
                print("Refreshing table")
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
            self.tblEntries.reloadData()
        })
            self.tblEntries.reloadData()
    }
    
    func showEntry(id:String){
        entryManager?.getEntryBdId(id:id,completion: { entry in
            if let entry = entry {
                print(entry.description)
            } else {
                print("ListViewController/showEntry: Couldn't fetch data")
            }
        })
    }
    
    /// Setting the amount of items to be shown in the view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (entryManager?.getEntriesList().count)!
    }
    
    /// Creating a cell for the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListViewControllerTableViewCell
        
        return configureCell(cell: cell, indexPath: indexPath)
    }
    
    /// Passing the clicked item to the next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEntry(id: (entryManager?.getEntriesList()[indexPath.row].id)!)
    }
    
    
    /// Configuring the params for a cell.
    /// Changing the text of the 3 labels: Title, Date, Amount
    /// - Parameters:
    ///   - cell: cell to modify/configure
    ///   - indexPath: index of the cell within the array
    /// - Returns: modified cell
    func configureCell(cell:ListViewControllerTableViewCell, indexPath:IndexPath) -> ListViewControllerTableViewCell{
        let entry: EntryModel
        entry = (entryManager?.getEntriesList()[indexPath.row])!
        
        cell.lblTitle.text = entry.title
        cell.lblDate.text = DateFormatter(ti: entry.createdAt).getFormattedDate()
        cell.lblAmount.text = String(format: "%.02f €", entry.amount)
        
        return cell
    }
}

