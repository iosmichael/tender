//
//  NotificationTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit
import Firebase

protocol NotificationButtonDelegate {
    func upperOptionTapped(cell:NotificationTableViewCell)
    func lowerOptionTapped(cell:NotificationTableViewCell)
    func thumbnailTapped(cell:NotificationTableViewCell)
    func singleOptionTapped(cell:NotificationTableViewCell)
}

enum NotificationType{
    case double
    case single
    case singleInfo
}

class NotificationTableViewCell: UITableViewCell {

    var notificationDelegate:NotificationButtonDelegate?

    var upperOption:UIButton = UIButton()
    var lowerOption:UIButton = UIButton()
    var singleOption:UIButton = UIButton()
    var detailText:UILabel = UILabel()
    var avatar:UIButton = UIButton()
    var labelWidth:CGFloat = 0 // should be initialized in init function
    
    var cellType:NotificationType?
    
    let gothamFont:UIFont = UIFont.init(name: "Seravek-ExtraLight", size: 19)!
    let defaultHeight:CGFloat = 75 // default cell height
    let smallSquare:CGFloat = 30
    let topMargin:CGFloat = 8  // also the gap between label and buttons
    let upperLowerGap:CGFloat = 3
    let rightMargin:CGFloat = 15
    let avatarSize:CGFloat = 45
    let leftMargin:CGFloat = 15
    let screenWidth:CGFloat = UIScreen.main.bounds.width
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //set subviews
        labelWidth = screenWidth-leftMargin-rightMargin-topMargin-smallSquare-avatarSize-10
        let upperView:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 3))
        upperView.backgroundColor = .flatWhite()
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(upperView)
        self.contentView.addSubview(upperOption)
        self.contentView.addSubview(lowerOption)
        self.contentView.addSubview(singleOption)
        self.contentView.addSubview(detailText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAvatarImage(uid:String){
        let ref = FIRDatabase.database().reference()
        let path = ref.child("users/\(uid)")
        path.observeSingleEvent(of: .value, with: { (snapshot) in
            for elem:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                if elem.key == "thumbnail" {
                    self.avatar.downloadedFrom(link: elem.value as! String)
                }
            }
        })
    }
    
    func fillType(description:String, type:NotificationType){
        cellType = type
        
        detailText.lineBreakMode = .byWordWrapping
        detailText.numberOfLines = 0

        let avatarLayout:CGRect = CGRect.init(x: leftMargin, y: 15, width: avatarSize, height: avatarSize)
        let upperOptionLayout:CGRect = CGRect.init(x: leftMargin+labelWidth+topMargin+avatarSize+10, y: topMargin, width: smallSquare, height: smallSquare)
        let lowerOptionLayout:CGRect = CGRect.init(x: leftMargin+labelWidth+topMargin+avatarSize+10, y: topMargin+smallSquare+upperLowerGap, width: smallSquare, height: smallSquare)
        let singleOptionLayout:CGRect = CGRect.init(x: leftMargin+labelWidth+topMargin+avatarSize+10, y: topMargin + smallSquare/2, width: smallSquare, height: smallSquare)
        let zeroLayout:CGRect = CGRect.zero
        avatar.frame = avatarLayout
        avatar.setImage(UIImage.init(named: "profile-test"), for: .normal)
        avatar.addTarget(self, action: #selector(thumbnailTapped), for: .touchUpInside)
        switch type {
        case .double:
            upperOption.frame = upperOptionLayout
            lowerOption.frame = lowerOptionLayout
            upperOption.addTarget(self, action: #selector(upperOptionTapped), for: .touchUpInside)
            lowerOption.addTarget(self, action: #selector(lowerOptionTapped), for: .touchUpInside)
            upperOption.setImage(UIImage.init(named: "check"), for: .normal)
            lowerOption.setImage(UIImage.init(named: "delete"), for: .normal)
            singleOption.frame = zeroLayout
            break
        case .single:
            singleOption.frame = singleOptionLayout
            singleOption.addTarget(self, action: #selector(singleOptionTapped), for: .touchUpInside)
            singleOption.setImage(UIImage.init(named: "delete"), for: .normal)
            upperOption.frame = zeroLayout
            lowerOption.frame = zeroLayout
            break
        case .singleInfo:
            singleOption.frame = singleOptionLayout
            singleOption.addTarget(self, action: #selector(singleOptionTapped), for: .touchUpInside)
            singleOption.setImage(UIImage.init(named: "info"), for: .normal)
            upperOption.frame = zeroLayout
            lowerOption.frame = zeroLayout
            break
        default:
            break
        }
        let labelHeight:CGFloat = description.heightWithConstrainedWidth(width: labelWidth, font: gothamFont)
        let textLayout:CGRect = CGRect.init(x: leftMargin+avatarSize+10, y: 20, width: labelWidth, height: labelHeight)
        detailText.frame = textLayout
        detailText.text = description
        detailText.font = gothamFont
    }
    
    func getCellHeight(description:String, type:NotificationType)->CGFloat{
        let labelHeight = description.heightWithConstrainedWidth(width: labelWidth, font: gothamFont)
        return (labelHeight + 4 * topMargin) - defaultHeight > 0 ? labelHeight + topMargin * 4 : defaultHeight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func upperOptionTapped(){
        notificationDelegate?.upperOptionTapped(cell: self)
    }
    
    func lowerOptionTapped(){
        notificationDelegate?.lowerOptionTapped(cell: self)
    }
    
    func thumbnailTapped(){
        notificationDelegate?.thumbnailTapped(cell: self)
    }
    
    func singleOptionTapped(){
        notificationDelegate?.singleOptionTapped(cell: self)
    }
    
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
}
