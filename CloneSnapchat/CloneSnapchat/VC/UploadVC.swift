//
//  UploadVC.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 10/02/2024.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseMessaging


class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadedView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadedView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        uploadedView.addGestureRecognizer(gestureRecognizer)

       
    }
    

    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadedView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadBtn(_ sender: Any) {
        
        //Storage part
        
        let storage = Storage.storage()
        let sReference = storage.reference()
        
        let media = sReference.child("media")
        
        
        if let data = uploadedView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imgRefernce = media.child("\(uuid).jpg")
            
            imgRefernce.putData(data, metadata: nil) { (metadata,error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else {
                    
                    imgRefernce.downloadURL { (url, error)  in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            // Firestor part
                            
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("username", isEqualTo: UsrSingle.sharedInstance.user).getDocuments { (snapshot, error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }else{
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                           
                                            let documentid = document.documentID
                                            
                                            if var imageArray = document.get("imageArray") as? [String]{
                                                imageArray.append(imageUrl!)
                                                
                                                let bonusDictionary = ["imageArray" : imageArray] as [String:Any]
                                                firestore.collection("Snaps").document(documentid).setData(bonusDictionary, merge: true) { (error) in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadedView.image = UIImage(systemName: "photo.badge.plus.fill")
                                                    }
                                                }
                                            }
                                        }
                                    }else {
                                        let snapDict = ["username": UsrSingle.sharedInstance.user, "imageArray": [imageUrl!], "date": FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        firestore.collection("Snaps").addDocument(data: snapDict) { (error) in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                
                                            }else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadedView.image = UIImage(systemName: "photo.badge.plus.fill")
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func makeAlert (title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true)
    }
    
}
