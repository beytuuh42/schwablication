//
//  ExtendedListViewController.swift
//  schwablication
//
//  Created by bi on 30.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ExtendedListViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photoImaveView: UIImageView!
    
    var entry:EntryModel?
    var refEntries: DatabaseReference?
    var entryManager:EntryManager?
    var picker = UIImagePickerController()
    var didChange = false

    /// Downloading the image for the entry and replacing it with the
    /// loading.gif imageview when finished.
    override func viewDidLoad() {
        view.accessibilityIdentifier = "extendedView"
        photoHandler(iv: photoImaveView)
        if(entry?.photo != ""){
            photoImaveView.image = UIImage.gif(asset: "loading")
            ImageHelper().downloadImageByUrl(url: (entry?.photo)!, image: self.photoImaveView)
        }
        keyboardHandler()
        super.viewDidLoad()
        
        self.amountTextField.delegate = self
        self.descriptionTextField.delegate = self
        self.titleTextField.delegate = self
        self.dateTextField.delegate = self
        
    }
    
    /// Loading entry data into the fields.
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationItem.setHidesBackButton(false, animated:true)
        amountTextField.text = String(format: "%.02f", (entry?.amount)!)
        titleTextField.text = entry?.title
        descriptionTextField.text = entry?.desc
        dateTextField.text = DateFormatter(ti: (entry?.createdAt)!).getFormattedDate()
    }
    
    
    /// Button event handler for "Save". Updating the entry to firebase.
    @IBAction func saveOnClick(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let desc = descriptionTextField.text else { return }
        guard let amountString = amountTextField.text else { return }
        let amount = Double(amountString)!
        updateEntryAndPopView(title: title, desc: desc, amount: amount)
    }

    
    /// Adding tap gesture to the incoming imageview
    ///
    /// - Parameter iv: imageview to add the gesture
    func photoHandler(iv:UIImageView){
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        iv.isUserInteractionEnabled = true
    }
    
    
    
    /// Handling the update of an entry.
    /// Checking if there is a new image and uploading if so.
    /// Otherwise simply updating the data and finally popping the view.
    ///
    /// - Parameters:
    ///   - title: new title of entry
    ///   - desc: new desc of entry
    ///   - amount: new amount of entry
    func updateEntryAndPopView(title:String,desc:String,amount:Double){
        if(!didChange){
            let newEntry = EntryModel(id: (entry?.id)!, title: title, desc: desc, amount: amount, createdAt: (entry?.createdAt)!, photo: (entry?.photo)!, category: (entry?.category)!)
            entryManager?.updateEntryById(entry: newEntry)
            navigationController?.popViewController(animated: true)
        } else {
            var image = UIImage.gif(asset: "loading")
            var imageView = UIImageView(image: image!)
            imageView.alpha = 0.5
            let x = self.view.frame.size.width/4
            let y = self.view.frame.size.height/3
            imageView.frame = CGRect(x: x, y: y, width: 200, height: 200)
            self.view.addSubview(imageView)
            
            let imgHelper = ImageHelper()
            let imgView = UIImageView()
            imgView.image = UIImage.gif(asset: "loading")
            imgView.contentMode = .scaleAspectFit
            imgHelper.uploadImageToStorage(imgHelper.resizeImage(image: photoImaveView.image!, targetSize: CGSize(width:300.0, height:300.0)), completionBlock: { (fileUrl, errorMessage) in
                let newEntry = EntryModel(id: (self.entry?.id)!, title: title, desc: desc, amount: amount, createdAt: (self.entry?.createdAt)!, photo: (fileUrl?.absoluteString)!, category: (self.entry?.category)!)
                self.entryManager?.updateEntryById(entry: newEntry)
                image = nil
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

extension ExtendedListViewController: UIImagePickerControllerDelegate{
    
    /// Asking permission to use camera and opening it or
    /// popping an alert message to change the settings.
    func openCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                print("access")
                self.useCamera()
            } else {
                print("no access")
                let alert  = UIAlertController(title: "Warning", message: "App doesn't have camera access. Enable it in your settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Opening the gallery of the phone.
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    /// Actually opening the camera of the phone.
    func useCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /// Setting the image of the entry to the chosen one from the camera or gallery.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            photoImaveView.image = image
            didChange = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Dismissing the image picker when pressing cancel.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ExtendedListViewController: UINavigationControllerDelegate{
    
    /// Popping a menu to choose between "Camera", "Gallery" and "Cancel"
    @objc func handleSelectImageView(){
        picker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func keyboardHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        self.scrollView.endEditing(true)
    }
}
