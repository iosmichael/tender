//
//  ChatViewController.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import ChameleonFramework

class ChatViewController: JSQMessagesViewController {
    
    var currentUser:User?
    var otherUser:User?
    
    var messages = [JSQMessage]()
    
    func setSenderOther(sender:User, other:User){
        self.currentUser = sender
        self.otherUser = other
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        if message.senderId == currentUser!.uid{
            cell.textView.textColor = .black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId:senderId, displayName:senderDisplayName, text:text)
        messages.append(message!)
        MessageManager().sendMessage(toId: (otherUser?.uid!)!, content: text)
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.row]
        let messageUsername = message.senderDisplayName
        if currentUser!.uid == message.senderId{
            return nil
        }
        return NSAttributedString(string: messageUsername!)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.row]
        if currentUser!.uid == message.senderId{
            return 10
        }
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        if currentUser!.uid != message.senderId {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage.init(named: "profile-test"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        }else{
            return nil
        }
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        return
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.row]
        
        if currentUser!.uid == message.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .flatWhite())
        }else{
            return bubbleFactory?.incomingMessagesBubbleImage(with: .flatSkyBlue())
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tell JSQMessagesViewController
        //who is the current user
        self.senderId = currentUser!.uid
        self.senderDisplayName = currentUser!.name
        self.inputToolbar.contentView.leftBarButtonItemWidth = 0
        self.inputToolbar.contentView.textView.layer.borderColor = UIColor.clear.cgColor
        self.inputToolbar.contentView.textView.backgroundColor = .flatWhite()
        self.inputToolbar.contentView.backgroundColor = .flatWhite()
        self.inputToolbar.contentView.rightBarButtonItem.setTitleColor(.flatSkyBlue(), for: .normal)
        getMessages(uid: currentUser!.uid!, username: currentUser!.name!, otherId: otherUser!.uid!, othername: otherUser!.name!) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatViewController{
    func getMessages(uid:String, username:String, otherId:String, othername:String, callback:@escaping (_:[JSQMessage])->Void){
        var jsqMessages = [JSQMessage]()
        let manager = MessageManager()
        manager.getMessages(uid: uid, otherId: otherId) { (messages) in
            for message in messages{
                var jsqMessage:JSQMessage?
                if message.isMe! {
                    jsqMessage = JSQMessage(senderId:uid, displayName:username, text:message.content!)
                }else{
                    jsqMessage = JSQMessage(senderId:otherId, displayName:othername, text:message.content!)
                }
                jsqMessages.append(jsqMessage!)
            }
            callback(jsqMessages)
        }
    }
}
