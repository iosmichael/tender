//
//  UserManager.swift
//  Tender
//
//  Created by Michael Liu on 1/27/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

class UserManager: NSObject {
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    func findUser(uid:String)->User{
        let path = self.ref.child("users/\(uid)")
        let user = User()
        path.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as? [String : AnyObject] ?? [:]
            user.credit = userDict["credit"] as! NSInteger?
            user.uid = uid
            user.email = userDict["email"] as! String?
            user.name = userDict["name"] as! String?
        })
        return user
    }
    
    func getHistory(uid:String)->[History]{
        let path = self.ref.child("users/\(uid)/complete")
        
        return []
    }
    
    func parseHistoryData(child:FIRDataSnapshot)->History{
        let history = History()
        switch child.key {
        case "title":
            break
        default:
            break
        }
        return history
    }
    
    func updateUser(){
        let currentUser = getCurrentUserData()
        if currentUser == nil{
            return
        }
        let uid = currentUser?["uid"]!
        let path = self.ref.child("users/\(uid)")
        path.setValue(currentUser?["name"], forKey: "name")
        path.setValue(currentUser?["email"], forKey: "email")
        path.setValue(currentUser?["thumbnail"], forKey: "thumbnail")
    }
}
