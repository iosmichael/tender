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
        var credit = getCredit(uid: uid)
        credit += by
        setCredit(uid: uid, with: credit)
    }
    
    public func deleteCredit(uid:String, by:NSInteger){
        var credit = getCredit(uid: uid)
        credit += by
        setCredit(uid: uid, with: credit)
    }
    
    func getCredit(uid:String)->NSInteger{
        let creditPath = self.ref.child("users/\(uid)")
        let credit = creditPath.value(forKey: "credits") as! String?
        if credit == nil {
            creditPath.child("credits").setValue(defaultCredit)
            return Int(defaultCredit)!
        }
        return Int(credit!)!
    }
    
    func setCredit(uid:String, with:NSInteger){
        let creditPath = self.ref.child("users/\(uid)")
        creditPath.setValue("\(with)", forKey:"credits")
    }
    
}
