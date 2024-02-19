//
//  ViewController.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 10/02/2024.
//

import UIKit
import Firebase

class SignIn: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passTF: UITextField!
    
    @IBOutlet weak var usrTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtn(_ sender: Any) {
        if emailTF.text != "" && usrTF.text != "" && passTF.text != "" {
            Auth.auth().signIn(withEmail: emailTF.text!, password: passTF.text!) { (result,error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else{
                    self.shouldPerformSegue(withIdentifier: "toVC1", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(title: "Error", message: "Empty field")
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        if emailTF.text != "" && usrTF.text != "" && passTF.text != "" {
       
                   Auth.auth().createUser(withEmail: emailTF.text!, password: passTF.text!) { (auth, error) in
                       if error != nil {
                           self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                       }else{
       
                           let firestore = Firestore.firestore()
       
                           let usrDictionary = ["email" : self.emailTF.text!, "username" : self.usrTF.text!] as [String : Any]
       
                           firestore.collection("User").addDocument(data: usrDictionary) { (error) in
                               if error != nil {
                                   self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                               }
                           }
       
                           self.performSegue(withIdentifier: "toVC1", sender: nil)
                       }
                   }
       
               }else {
                   self.makeAlert(title: "Error", message: "Empty field")
       
               }
    }
    
    

    func makeAlert (title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true)
    }
}

