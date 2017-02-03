//
//  MessageManager.swift
//  Tender
//
//  Created by Michael Liu on 1/27/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

class MessageManager: NSObject {
    
    var ref:FIRDatabaseReference = FIRDatabase.database().reference()
    
    func sendMessage(toId:String, content:String){
        let date = Date()
        let dateFormatter = DateFormatter()
        let now = dateFormatter.string(from: date)
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        let myMPath = ref.child("messages/\(uid)/\(toId)").childByAutoId()
        myMPath.setValue([
            "content":content,
            "date":now,
            "isMe":"\(true)"
            ])
        let otherMPath = ref.child("messages/\(toId)/\(uid)").childByAutoId()
        otherMPath.setValue([
            "content":content,
            "date":now,
            "isMe":"\(false)"
            ])
    }
    
    func getMessages(uid:String, otherId:String, callback:@escaping (_:[Message])->()){
        let myMPath = ref.child("messages/\(uid)/\(otherId)")
        myMPath.queryOrdered(byChild: "date").queryLimited(toLast: 40).observe(.childAdded, with: { (snapshot) in
            var messages:[Message] = []
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                let message = self.parseMessageData(child: child)
                messages.append(message)
            }
            callback(messages)
        })
    }
    
    func parseMessageData(child:FIRDataSnapshot)->Message{
        let message = Message()
        let dateFormatter = DateFormatter()
        for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
            switch elem.key {
            case "content":
                message.content = elem.value as? String
                break
            case "date":
                message.date = dateFormatter.date(from:elem.value as! String)
                break
            case "isMe":
                let isMe = elem.value as! String
                message.isMe = Bool(isMe)
                break
            default:
                break
            }
        }
        return message
    }
    
}
