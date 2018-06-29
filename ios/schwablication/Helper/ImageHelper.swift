//
//  ImageHelper.swift
//  schwablication
//
//  Created by bi on 29.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation
import Firebase

class ImageHelper: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // photo
    var picker:UIImagePickerController
    let storageRef = Storage.storage().reference().child("images")
    var registerRef:Any
    
    init(registerRef:Any){
        self.registerRef = registerRef
        self.picker = UIImagePickerController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func openMenu(){
        picker.delegate = registerRef as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        picker.allowsEditing = true
        
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
    
    
    func uploadImage(_ image:UIImage, completionBlock: @escaping(_ url:URL?, _ errorMessage: String?) -> Void){
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            uploadImage(image, completionBlock: { (fileUrl, errorMessage) in
                print(fileUrl)
                print(errorMessage)
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
