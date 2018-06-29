//
//  RegisterViewController.swift
//  schwablication
//
//  Created by bi on 29.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var txtField_pass: UITextField!
    @IBOutlet weak var txtField_email: UITextField!
    
    
    
    
    // photo
    var picker = UIImagePickerController()
    let storageRef = Storage.storage().reference().child("images")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func handleRegister(){
        let email = txtField_email.text!
        let pass = txtField_pass.text!
        let alertController = Alert()
        if(!email.isEmpty && !pass.isEmpty){
            Auth.auth().createUser(withEmail: email, password: pass) { user, error in
                if error == nil && user != nil {
                    print("User created")
                    let alertController = UIAlertController(title: "Success", message: "User created", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        print("ok?")
                        self.performSegue(withIdentifier: "toLoginScreen", sender: self)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                } else {
                    print("Error creating user")
                    print()
                    alertController.showBasic(title: "Error creating account", message: error!.localizedDescription , vc: self)
                }
            }
        } else {
            alertController.showBasic(title: "Incomplete Form", message: "E-Mail and password field are required." , vc: self)
        }
    }
    
    @IBAction func onButtonClickCreateAccount(_ sender: UIButton) {
        //handleRegister()
        handleSelectImageView(sender:sender)
    }
    
    
    
    /// PHOTO ZEUGS
    
//    func photoHandler(iv:UIImageView){
//        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
//        iv.isUserInteractionEnabled = true
//    }
    
    
    /// extenden: UIImagePickerControllerDelegate, UINavigationControllerDelegate
    @objc func handleSelectImageView(sender:UIButton){
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

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            uploadImageToStorage(resizeImage(image: image, targetSize: CGSize(width:200.0, height:200.0)), completionBlock: { (fileUrl, errorMessage) in
                print(fileUrl)
                print(errorMessage)
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToStorage(_ image:UIImage, completionBlock: @escaping(_ url:URL?, _ errorMessage: String?) -> Void){
        let imageName = "\(Date().timeIntervalSince1970).png"
        let imageRef = storageRef.child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            let uploadTask = imageRef.putData(imageData,metadata:metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            
        } else {
            completionBlock(nil, "Image couldn't be converted to data")
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
