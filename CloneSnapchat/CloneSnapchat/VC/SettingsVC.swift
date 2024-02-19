//
//  SettingsVC.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 10/02/2024.
//

import UIKit
import Firebase
class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logOut(_ sender: Any) {
                do{
                    try Auth.auth().signOut()
                        self.performSegue(withIdentifier: "toSign", sender: nil)
        
                }catch{
        
                }
            }
          
        
    }
    


