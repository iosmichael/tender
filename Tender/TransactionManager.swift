//
//  TransactionManager.swift
//  Tender
//
//  Created by Michael Liu on 1/28/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

//Transaction includes three different stages: request, deliver and finish
//code will help prevent concurrency problems
class TransactionManager: NSObject {
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    func getTransactions(uid:String, reloadFunc:@escaping (_:[Transaction])->Void){
        let transPath = self.ref.child("transactions/\(uid)")
        transPath.queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            var transactions:[Transaction] = []
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let transaction = self.parseTransaction(child: child)
                transactions.append(transaction)
            }
            reloadFunc(transactions)
        })
    }
    
    //buyer can cancel request, provider can cancel request as well
    //if provider accept request, then transaction goes to the next stage
    func requestAction(transaction:Transaction, isProvider:Bool, didAccept:Bool, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "request"){ return }
        if isProvider && didAccept {
            deliverStage(transaction: transaction, uid: uid)
        }else if !didAccept{
            //cancel
            cancelStage(transaction: transaction, uid: uid)
        }
    }
    
    //buyer can only contact with provider at this stage, while provider can either cancel delivering the service
    //or report to the system that the service is complete
    func deliverAction(transaction:Transaction, isProvider:Bool, didComplete:Bool, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "deliver"){ return }
        if isProvider && didComplete {
            //transaction moves to the next state
            finishStage(transaction:transaction, uid: uid)
        }else if isProvider {
            //cancel and the buyer receive refund
            refundStage(transaction: transaction, uid: uid)
        }
    }
    
    //buyer has the option to accept or decline
    //if accept, system will ask buyers to rate the service
    //if decline, system will post refund issue
    func finishAction(transaction:Transaction, isProvider:Bool, didAccept:Bool, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "finish"){ return }
        if isProvider && didAccept {
            //complete
            completeStage(transaction: transaction, uid: uid)
        }else if isProvider && !didAccept{
            //cancel
            refundStage(transaction: transaction, uid: uid)
        }else if !isProvider && didAccept{
            //NEED TO IMPLEMENT CREDIT MANAGER TO ADD CREDIT WITHOUT FALLOUT
            //CreditManager().addCredit(uid: uid, by: Int(transaction.credit)!)
            deleteTransaction(transaction: transaction, uid: uid)
        }else{
            //NEED TO IMPLEMENT REFUND MANAGER TO ADD REFUND ISSUE HERE
            //refund issue
            deleteTransaction(transaction: transaction, uid: uid)
        }
    }
    
    func completeAction(transaction:Transaction, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "complete"){ return }
        let isProvider = transaction.isProvider
        if isProvider {
           CreditManager().addCredit(uid: uid, by: Int(transaction.credit)!)
        }
        deleteTransaction(transaction: transaction, uid:uid)
    }
    
    func refundAction(transaction:Transaction, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "refund"){ return }
        let isProvider = transaction.isProvider
        if isProvider {
            CreditManager().addCredit(uid: uid, by: Int(transaction.credit)!)
        }else if !isProvider {
            postRefundIssue(transaction: transaction, uid: uid)
        }
        deleteTransaction(transaction: transaction, uid: uid)
    }
    
    func cancelAction(transaction:Transaction, uid:String){
        //if !checkTransactionState(transaction: transaction, uid: uid, state: "cancel"){ return }
        deleteTransaction(transaction: transaction, uid: uid)
    }
    
    private func deleteTransaction(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)").setValue(nil)
    }
    
    func parseTransaction(child:FIRDataSnapshot)->Transaction {
        let transaction = Transaction()
        transaction.id = child.key
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
            case "user":
                transaction.user = elem.value as! String
                break
            case "isProvider":
                transaction.isProvider = elem.value as! String == "true"
                break
            case "state":
                transaction.state = elem.value as! String
                break
            default:
                break
            }
        }
        return transaction
    }
    
    func checkTransactionState(transaction:Transaction, uid:String, state:String) -> Bool{
        let myState = self.ref.child("transactions/\(uid)/\(transaction.id)").value(forKey: "state") as! String
        let otherState = self.ref.child("transactions/\(transaction.user)/\(transaction.id)").value(forKey: "state") as! String
        return myState == otherState && otherState == state
    }
    
    func deliverStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("deliver")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("deliver")
    }
    
    func finishStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("finish")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("finish")
    }
    
    func completeStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("complete")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("complete")
    }
    
    func refundStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("refund")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("refund")
    }
    
    func cancelStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("cancel")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("cancel")
    }
    
    func complaintStage(transaction:Transaction, uid:String){
        self.ref.child("transactions/\(uid)/\(transaction.id)/state").setValue("complaint")
        self.ref.child("transactions/\(transaction.user)/\(transaction.id)/state").setValue("complaint")
    }
    
    func postTransaction(transaction:Transaction, uid:String){
        let transactionPath = self.ref.child("transactions/")
        let myPath = transactionPath.child(uid).childByAutoId()
        let pathArr = myPath.key.components(separatedBy: "/")
        let autoId = pathArr[pathArr.count-1]
        let date = convertDatetoString(date: Date())
        var dataDict = ["user":transaction.user,
                        "service":transaction.service,
                        "state":transaction.state,
                        "serviceId":transaction.serviceId,
                        "date":date,
                        "credit":transaction.credit,
                        "isProvider":"\(transaction.isProvider)"]
        myPath.setValue(dataDict)
        let otherPath = transactionPath.child(transaction.user).child(autoId)
        dataDict["isProvider"] = "\(!transaction.isProvider)"
        dataDict["user"] = uid
        otherPath.setValue(dataDict)
        //delete service
    }
    
    func postRefundIssue(transaction:Transaction, uid:String){
        let refundPath = self.ref.child("refunds/\(uid)")
        let data = [
            "user":uid,
            "credit":transaction.credit,
            "service":transaction.service,
            "provider":transaction.user
        ]
        refundPath.childByAutoId().setValue(data)
    }
    
}
