//
//  User.swift
//  Tender
//
//  Created by Michael Liu on 1/26/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class User: NSObject {
    var name:String?
    var uid:String?
    var credit:NSInteger?
    var email:String?
    var thumbnail:String?
}

extension NSObject{
    func getCurrentUserData()->[String:String]?{
        let currentUser = GIDSignIn.sharedInstance().currentUser
        let notSignIn = FIRAuth.auth()?.currentUser == nil
        if notSignIn {
            print("User has not signed in")
            return nil
        }
        let uid = currentUser?.userID
        let name = currentUser?.profile.name
        let thumbnail = currentUser?.profile.imageURL(withDimension: 200).absoluteString
        let data = ["uid": uid!,
                    "provider":name!,
                    "thumbnail":thumbnail!] as [String : String]
        UserDefaults.standard.setValue(uid, forKey: "uid")
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.setValue(thumbnail, forKey: "thumbnail")
        return data
    }
}
