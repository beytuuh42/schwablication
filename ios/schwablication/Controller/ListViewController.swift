//
//  ListViewController.swift
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
    var selectedIndex = 0
    
    /// Loading the application.
    /// Declaring the references for our database and model manager class.
    /// Loading data into the view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "listView"
        refEntries = Database.database().reference().child("entries")
        entryManager = EntryManager(refEntries: self.refEntries)
        
         }
    
    /// Refreshing table content before view is appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTable()
    }
    
    /// After completion of fetching, reloading the table for the view
    func refreshTable(){
        entryManager?.fetchAllData(completion: { entry in
            if entry != nil {
                print("Refreshed table")
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
            self.tblEntries.reloadData()
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
    
    /// Preparing the extended list view by setting variables.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExtendedScreen" {
            let vc : ExtendedListViewController = segue.destination as! ExtendedListViewController
            vc.entry = entryManager?.getEntriesList()[selectedIndex]
            vc.entryManager = entryManager
            vc.refEntries = refEntries
        }
    }
    
    /// Passing the clicked item to the next view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toExtendedScreen", sender: self)
    }
    
    func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Delete element by swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // handle delete (by removing the data from your array and updating the tableview)
            entryManager?.deleteEntryById(id: (entryManager?.getEntriesList()[indexPath.row].id)!, index:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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
        
        if(entry.category == Category.Ausgaben.description){
            cell.lblAmount.textColor = UIColor.red
        } else {
            cell.lblAmount.textColor = UIColor.init(red: 0, green: 0.7, blue: 0.1, alpha: 1)
        }
        
        return cell
    }
    
    /// Button event handler for "Logout".
    /// Signing out the user by firebase and navigating to the loginview.
    @IBAction func logoutButtonOnClick(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
}

