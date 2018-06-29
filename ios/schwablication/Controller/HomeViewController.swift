//
//  HomeViewController.swift
//  schwablication
//
//  Created by Ehsan Rajol && Beytullah Ince on 15.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
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
    
    /// Displayed chart values
    var inDataEntry = PieChartDataEntry(value: 0.0)
    var outDataEntry = PieChartDataEntry(value: 0.0)
    var inOutDataEntries = [PieChartDataEntry]()
    
    /// Loading the handler for the keyboard, getting references
    /// and loading data.
    override func viewDidLoad() {
        keyboardHandler()
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        self.titleTextField.delegate = self
        
        refEntries = Database.database().reference().child("entries")
        entryManager = EntryManager(refEntries: self.refEntries)
    }
    
    /// Loading data before view is appearing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    /// Loading data from firebase then setting up data for the pie chart
    func loadData(){
        entryManager?.fetchInOutAmount(category: Category.Ausgaben.description, completion: { entry in
            if entry != nil {
                self.setPieChartData()
            } else {
                print("ListViewController/refreshTable: Couldn't fetch data")
            }
        })
    }
    
    /// Setting up pie chart data
    func setPieChartData() {
        setIncPieChartData()
        setOutPieChartData()
        self.pieChart.chartDescription?.text = ""
        self.pieChart.legend.enabled = false
        self.inOutDataEntries = [self.inDataEntry, self.outDataEntry]
        self.updateChartData()
    }
    
    /// Setting up pie chart data for incomings
    func setIncPieChartData(){
        self.inDataEntry.label = Category.Einkommen.description
        self.inDataEntry.value = (self.entryManager?.getTotalIncAmount())!
    }
    
    /// Setting up pie chart data for outgoing
    func setOutPieChartData() {
        self.outDataEntry.value = (self.entryManager?.getTotalOutAmount())!
        self.outDataEntry.label = Category.Ausgaben.description
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
    
    /// Calculating the bilanz also showing it formatted on the pie chart
    func loadBilanz(){
        bilanz = (entryManager?.getTotalIncAmount())! - (entryManager?.getTotalOutAmount())!
        pieChart.centerText = String(format: "%.02f €", bilanz)
    }
    
    
    /// Clearing textfield input
    ///
    /// - Parameter textField: input to clear
    private func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    
    /// Checking if inputs are empty, after that saving it in firebase.
    /// Also refreshing pie chart and clearing textfields.
    ///
    /// - Parameter category: input to clear
    func addDataToFirebase(category:String){
        if (isEmptyInput()){
            Alert().showBasic(title: "Incomplete Form", message: "Amount and Title field is required." , vc: self)
            
        } else {
            entryManager!.addEntry(title: titleTextField.text!, amount: Double(amountTextField.text!)!,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             category: category)
            
            loadData()
            textFieldDidBeginEditing(textField: amountTextField)
            textFieldDidBeginEditing(textField: titleTextField)
        }
    }
    
    
    /// Checking if input textfields are empty
    ///
    /// - Returns: whether it's empty or not
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

