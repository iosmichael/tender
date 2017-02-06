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
    
    func findUser(uid:String, callback:@escaping (_:User)->Void){
        let path = self.ref.child("users/\(uid)")
        path.observeSingleEvent(of: .value, with: { (snapshot) in
            let user = self.parseUserData(child: snapshot)
            callback(user)
        })
    }
    
    func getUsers(query:String, callback:@escaping (_:[User])->Void){
        let path = self.ref.child("users")
        var dataQuery:FIRDatabaseQuery?
        if query.isEmpty {
            dataQuery = path.queryLimited(toFirst: 10)
        }else{
            dataQuery = path.queryStarting(atValue: query, childKey: "name").queryLimited(toFirst: 10)
        }
        dataQuery?.observe(.value, with: { (snapshot) in
            var users:[User] = []
            for child in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let user = self.parseUserData(child: child)
                users.insert(user, at: 0)
            }
            callback(users)
        })
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
    
    func parseUserData(child:FIRDataSnapshot)->User{
        let user = User()
        user.uid = child.key
        for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
            switch elem.key{
            case "email":
                user.email = elem.value as! String
                break
            case "name":
                user.name = elem.value as! String
                break
            case "thumbnail":
                user.thumbnail = elem.value as! String
                break
            default:
                break
            }
        }
        return user
    }
}
