//
//  ImageHelper.swift
//  schwablication
//
//  Created by bi on 29.06.18.
//  Copyright © 2018 Hochschule der Medien. All rights reserved.
//

import Foundation
import Firebase

class ImageHelper {
    
    let storageRef: StorageReference
    let refEntries: DatabaseReference
    
    init(){
        storageRef = Storage.storage().reference().child("images")
        refEntries = Database.database().reference().child("entries")
    }
    
    func uploadImageToStorage(_ image:UIImage, completionBlock: @escaping(_ url:URL?, _ errorMessage: String?) -> Void){
        let imageName = "\(Date().timeIntervalSince1970).png"
        let imageRef = storageRef.child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8){
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            _ = imageRef.putData(imageData,metadata:metadata, completion: { (metadata, error) in
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
    
    func downloadImageByUrl(url:String, image:UIImageView){
        let storageRef = Storage.storage().reference(forURL: url)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 300 * 300) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            image.image = UIImage(data: data!)
        }
    }
}
