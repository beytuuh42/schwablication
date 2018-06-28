//
//
//  schwablication
//
//  Created by Ehsan Rajol on 15.06.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import Charts
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bilanzLabel: UILabel!
    var refEntries: DatabaseReference!
    var entryManager:EntryManager?
    
    
    
    
    // Bilanz betrag muss hier von db aufgerufen werden
    var bilanz = 99.79
    
    
    // button to add amount and title to list and chart
    @IBAction func addButton(_ sender: AnyObject) {
        
        if (amountTextField.text?.isEmpty)! || (titleTextField.text?.isEmpty)! {
            Alert.showBasic(title: "Incomplete Form", message: "Amount and Title field is required." , vc: self)
        } else {
            entryManager!.addEntry(title: titleTextField.text!, amount: Double(amountTextField.text!)!,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             category: Category.Einkommen.description)
            
        }
        
        pieChart.centerText = String(bilanz)
        updateChartData()
        
        
        textFieldDidBeginEditing(textField: amountTextField)
        textFieldDidBeginEditing(textField: titleTextField)
    }
    
    
    
    
    
    
    // button to add amount and title to list and chart, but for outputs amounts
    
    @IBAction func minusButton(_ sender: AnyObject) {
        if (amountTextField.text?.isEmpty)! || (titleTextField.text?.isEmpty)! {
            Alert.showBasic(title: "Incomplete Form", message: "Amount and Title field is required." , vc: self)
            
        } else {
            entryManager!.addEntry(title: titleTextField.text!, amount: Double(amountTextField.text!)!,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             category: Category.Ausgaben.description)
            
        }
        
        pieChart.centerText = String(bilanz)
        updateChartData()
        
        
        textFieldDidBeginEditing(textField: amountTextField)
        textFieldDidBeginEditing(textField: titleTextField)
    }
    
    
    
    
    
    var inDataEntry = PieChartDataEntry(value: 0)
    var outDataEntry = PieChartDataEntry(value: 0)
    
    var inOutDataEntries = [PieChartDataEntry]()
    
    
    // keyboard will show
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // keyboard will hide
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // hide keyboard, when touches outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        super.viewDidLoad()
        
        
        refEntries = Database.database().reference().child("entries")
        entryManager = EntryManager(refEntries: self.refEntries)
        loadAmount()
        loadBilanz()
        
        
        self.amountTextField.delegate = self
        self.titleTextField.delegate = self
        
        
        pieChart.chartDescription?.text=""
        pieChart.legend.enabled = false
        
        inOutDataEntries = [inDataEntry, outDataEntry]
        
        updateChartData()
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    // for setup and update your Piechart
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: inOutDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named:"inColor"), UIColor(named:"outColor")]
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
        pieChart.animate(xAxisDuration: 2, yAxisDuration: 2)
        
        
    }
    
    
    
    func loadAmount(){
        entryManager?.fetchTotalAmount(completion: { entry in
            if entry != nil {
                self.inDataEntry.label = "Einkommen"
                self.inDataEntry.value = (self.entryManager?.getTotalIncAmount())!
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
        })
        entryManager?.fetchInOutAmount(category: Category.Ausgaben.description, completion: { entry in
            if entry != nil {
                self.outDataEntry.value = (self.entryManager?.getTotalOutAmount())!
                self.outDataEntry.label = "Ausgaben"
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
        })
    }
    
    
    func loadBilanz(){
        
        bilanz = (entryManager?.getTotalIncAmount())! - (entryManager?.getTotalOutAmount())!
        updateChartData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

