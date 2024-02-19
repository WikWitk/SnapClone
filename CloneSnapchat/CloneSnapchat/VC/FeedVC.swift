//
//  FeedVC.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 10/02/2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    
    let firestore = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    
    @IBOutlet weak var feedtTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        feedtTV.delegate = self
        feedtTV.dataSource = self
        
        
       getSnapsFromBase()
       getInfo()
    }
    
    func getSnapsFromBase(){
        firestore.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("username") as? String {
                            if let imageArray = document.get("imageArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let differnece = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if differnece >= 24 {
                                            self.firestore.document(documentId).delete { (error) in
                                            }
                                            }else {
                                                let snap = Snap(username: username, imageArray: imageArray, date: date.dateValue(),timeDifference: 24 - differnece)
                                                self.snapArray.append(snap)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                    self.feedtTV.reloadData()
                    
                }
            }
        
        
        
    }
    
    func getInfo(){
        
        firestore.collection("User").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String{
                            UsrSingle.sharedInstance.email = Auth.auth().currentUser!.email!
                            UsrSingle.sharedInstance.user = username
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedtTV.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userNameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageArray[0]))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
}
