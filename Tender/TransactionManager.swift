//
//  TransactionManager.swift
//  Tender
//
//  Created by Michael Liu on 1/28/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

class TransactionManager: NSObject {
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    func getTransactions(uid:String)->[Transaction]{
        let transPath = self.ref.child("transactions/\(uid)")
        var transactions:[Transaction] = []
        transPath.queryOrdered(byChild: "date").observe(.childAdded, with: { (snapshot) in
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let transaction = self.parseTransaction(child: child)
                transactions.append(transaction)
            }
        })
        return transactions
    }
    
    func nextState(state:String){
        var nextState = ["request":"pending", "pending":"affirm", "affirm":"finished"]
        var quickState = ["request":"transfer", "transfer":"finished"]
    }
    
    func createTransaction(service:Service ,provider:String, uid:String){
        let transPath = self.ref.child("transactions/\(uid)").childByAutoId()
        let date = convertDatetoString(date: Date())
        let dataDict = ["credit":service.credits,
                        "date":date,
                        "provider":provider,
                        "service":service.title]
        transPath.setValue(dataDict)
    }
    
    func createQuickTransfer(from:User ,provider:User){
        //request -> credit taken from buyer
        //accept -> credit transfered
    }
    
    func finishQuickTransfer(transaction:Transaction, accept:Bool){
        
    }
    
    func parseTransaction(child:FIRDataSnapshot)->Transaction {
        var transaction = Transaction()
        for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
            switch elem.key {
            case "credit":
                transaction.credit = elem.value as! String
                break
            case "date":
                transaction.date = elem.value as! String
                break
            case "serviceId":
                transaction.serviceId = elem.value as! String
                break
            case "service":
                transaction.service = elem.value as! String
                break
            case "provider":
                transaction.provider = elem.value as! String
                break
            default:
                break
            }
        }
        return transaction
    }
    
}
