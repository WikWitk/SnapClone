//
//  UsrSingle.swift
//  CloneSnapchat
//
//  Created by Wiktor Witkowski on 14/02/2024.
//

import Foundation


class UsrSingle {
    
   static  let sharedInstance  = UsrSingle()
    
    var email = ""
    var user = ""
    
    private init() {
        
    }
}
