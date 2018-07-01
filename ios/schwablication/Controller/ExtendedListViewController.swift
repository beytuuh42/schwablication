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

class ExtendedListViewController: UIViewController {

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

    
    override func viewDidLoad() {
        view.accessibilityIdentifier = "extendedView"
        photoHandler(iv: photoImaveView)
        if(entry?.photo != ""){
            photoImaveView.image = UIImage.gif(asset: "loading")
            ImageHelper().downloadImageByUrl(url: (entry?.photo)!, image: self.photoImaveView)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amountTextField.text = String(format: "%.02f", (entry?.amount)!)
        titleTextField.text = entry?.title
        descriptionTextField.text = entry?.desc
        dateTextField.text = DateFormatter(ti: (entry?.createdAt)!).getFormattedDate()
    }
    
    @IBAction func saveOnClick(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let desc = descriptionTextField.text else { return }
        guard let amountString = amountTextField.text else { return }
        let amount = Double(amountString)!
        updateEntryAndPopView(title: title, desc: desc, amount: amount)
    }

    func photoHandler(iv:UIImageView){
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        iv.isUserInteractionEnabled = true
    }
    
    func updateEntryAndPopView(title:String,desc:String,amount:Double){
        if(!didChange){
            let newEntry = EntryModel(id: (entry?.id)!, title: title, desc: desc, amount: amount, createdAt: (entry?.createdAt)!, photo: (entry?.photo)!, category: (entry?.category)!)
            entryManager?.updateEntryById(entry: newEntry)
            self.performSegue(withIdentifier: "toListScreen", sender: self)
            //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            let imgHelper = ImageHelper()
            let imgView = UIImageView()
            imgView.image = UIImage.gif(asset: "loading")
            imgView.contentMode = .scaleAspectFit
            imgHelper.uploadImageToStorage(imgHelper.resizeImage(image: photoImaveView.image!, targetSize: CGSize(width:200.0, height:200.0)), completionBlock: { (fileUrl, errorMessage) in
                let newEntry = EntryModel(id: (self.entry?.id)!, title: title, desc: desc, amount: amount, createdAt: (self.entry?.createdAt)!, photo: (fileUrl?.absoluteString)!, category: (self.entry?.category)!)
                self.entryManager?.updateEntryById(entry: newEntry)
                self.performSegue(withIdentifier: "toListScreen", sender: self)
                //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

extension ExtendedListViewController: UIImagePickerControllerDelegate{
    
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
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            photoImaveView.image = image
            didChange = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ExtendedListViewController: UINavigationControllerDelegate{
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
}
