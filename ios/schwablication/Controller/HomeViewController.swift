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

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bilanzLabel: UILabel!
    var refEntries: DatabaseReference!
    var entryManager:EntryManager?
    
    var bilanz:Double = 0
    var inDataEntry = PieChartDataEntry(value: 0.0)
    var outDataEntry = PieChartDataEntry(value: 0.0)
    
    var inOutDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        keyboardHandler()
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        self.titleTextField.delegate = self
        
        refEntries = Database.database().reference().child("entries")
        entryManager = EntryManager(refEntries: self.refEntries)
        
        loadData()
    }
    
    // for setup and update your Piechart
    func updateChartData() {
        loadBilanz()

        let chartDataSet = PieChartDataSet(values: inOutDataEntries, label: nil)
        
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named:"inColor"), UIColor(named:"outColor")]
        chartDataSet.colors = colors as! [NSUIColor]
        pieChart.data = chartData
        pieChart.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    
    func loadData(){
        entryManager?.fetchInOutAmount(category: Category.Ausgaben.description, completion: { entry in
            if entry != nil {
                self.inDataEntry.label = "Einkommen"
                self.inDataEntry.value = (self.entryManager?.getTotalIncAmount())!
                self.pieChart.chartDescription?.text=""
                self.pieChart.legend.enabled = false
                
                self.inOutDataEntries = [self.inDataEntry, self.outDataEntry]
                self.updateChartData()

            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
        })
        entryManager?.fetchInOutAmount(category: Category.Ausgaben.description, completion: { entry in
            if entry != nil {
                self.outDataEntry.value = (self.entryManager?.getTotalOutAmount())!
                self.outDataEntry.label = "Ausgaben"
                self.pieChart.chartDescription?.text=""
                self.pieChart.legend.enabled = false
                
                self.inOutDataEntries = [self.inDataEntry, self.outDataEntry]
                print(self.entryManager?.getTotalOutAmount())
                self.updateChartData()
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
        })
        

    }
    
    
    func loadBilanz(){
        bilanz = (entryManager?.getTotalIncAmount())! - (entryManager?.getTotalOutAmount())!
        pieChart.centerText = String(format: "%.02f €", bilanz)
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    func addDataToFirebase(category:String){
        if (isEmptyInput()){
            Alert.showBasic(title: "Incomplete Form", message: "Amount and Title field is required." , vc: self)
            
        } else {
            entryManager!.addEntry(title: titleTextField.text!, amount: Double(amountTextField.text!)!,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             category: category)
            
            loadData()
            
            textFieldDidBeginEditing(textField: amountTextField)
            textFieldDidBeginEditing(textField: titleTextField)
        }
    }
    
    func isEmptyInput() -> Bool{
        if((amountTextField.text?.isEmpty)! || (titleTextField.text?.isEmpty)!){
            return true
        }
        return false
    }
    
    func keyboardHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button to add amount and title to list and chart
    @IBAction func addButton(_ sender: AnyObject) {
        addDataToFirebase(category: Category.Einkommen.description)
    }
    
    // button to add amount and title to list and chart, but for outputs amounts
    
    @IBAction func minusButton(_ sender: AnyObject) {
        addDataToFirebase(category: Category.Ausgaben.description)
    }
    
    
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
}

