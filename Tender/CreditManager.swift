//
//  CreditManager.swift
//  Tender
//
//  Created by Michael Liu on 1/28/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

class CreditManager: NSObject {
    
    final let defaultCredit = "20"

    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    //there might be concurrent problems
    public func addCredit(uid:String, by:NSInteger){
        getCredit(uid: uid, callback:{ (data) in
            var credit = data
            credit += by
            self.setCredit(uid: uid, with: credit)
        })
    }
    
    public func deleteCredit(uid:String, by:NSInteger){
        getCredit(uid: uid, callback:{ (data) in
            var credit = data
            credit -= by
            self.setCredit(uid: uid, with: credit)
        })
    }
    
    func getCredit(uid:String, callback:@escaping (_:NSInteger)->Void){
        let creditPath = self.ref.child("users/\(uid)/credit")
        creditPath.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value
            if value is NSNull {
                creditPath.setValue(self.defaultCredit)
                callback(Int(self.defaultCredit)!)
            }else{
                callback(Int(value as! String)!)
            }
        })
    }
    
    func setCredit(uid:String, with:NSInteger){
        let creditPath = self.ref.child("users/\(uid)")
        creditPath.setValue("\(with)", forKey:"credits")
    }
    
}
