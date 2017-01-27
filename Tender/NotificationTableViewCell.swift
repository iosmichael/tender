//
//  NotificationTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/25/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

protocol NotificationButtonDelegate {
    func upperOptionTapped(cell:NotificationTableViewCell)
    func lowerOptionTapped(cell:NotificationTableViewCell)
}

enum NotificationType{
    case request
    case finish
    case affirm
    case info
}

class NotificationTableViewCell: UITableViewCell {

    var notificationDelegate:NotificationButtonDelegate?
    
    var upperOption:UIButton = UIButton()
    var lowerOption:UIButton = UIButton()
    var detailText:UILabel = UILabel()
    var avatar:UIButton = UIButton()
    var labelWidth:CGFloat = 0 // should be initialized in init function
    
    let gothamFont:UIFont = UIFont.init(name: "Gotham-Book", size: 16)!
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
        self.contentView.addSubview(detailText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillType(whom:String, service:String, type:NotificationType){
        detailText.lineBreakMode = .byWordWrapping
        detailText.numberOfLines = 0
        var requestText:String?
        let avatarLayout:CGRect = CGRect.init(x: leftMargin, y: 15, width: avatarSize, height: avatarSize)
        let upperOptionLayout:CGRect = CGRect.init(x: leftMargin+labelWidth+topMargin+avatarSize+10, y: topMargin, width: smallSquare, height: smallSquare)
        let lowerOptionLayout:CGRect = CGRect.init(x: leftMargin+labelWidth+topMargin+avatarSize+10, y: topMargin+smallSquare+upperLowerGap, width: smallSquare, height: smallSquare)
        avatar.frame = avatarLayout
        avatar.setImage(UIImage.init(named: "profile-test"), for: .normal)
        
        upperOption.frame = upperOptionLayout
        lowerOption.frame = lowerOptionLayout
        upperOption.addTarget(self, action: #selector(upperOptionTapped), for: .touchUpInside)
        lowerOption.addTarget(self, action: #selector(lowerOptionTapped), for: .touchUpInside)
        switch type {
        case .request:
            requestText = whom + " has asked you for help with " + service
            upperOption.setImage(UIImage.init(named: "check"), for: .normal)
            lowerOption.setImage(UIImage.init(named: "delete"), for: .normal)
            break
        case .finish:
            requestText = whom + " has asked you for help with " + service
            upperOption.setImage(UIImage.init(named: "check"), for: .normal)
            lowerOption.setImage(UIImage.init(named: "delete"), for: .normal)
            break
        case .affirm:
            requestText = "Did " + whom + " finish helping you with " + service + "?"
            upperOption.setImage(UIImage.init(named: "check"), for: .normal)
            lowerOption.setImage(UIImage.init(named: "delete"), for: .normal)
            break
        default:
            //info
            requestText = whom + " accepted your request to help you with " + service
            upperOption.setImage(UIImage.init(named: "info"), for: .normal)
            lowerOption.setImage(UIImage.init(named: "delete"), for: .normal)
            break
        }
        let labelHeight:CGFloat = requestText!.heightWithConstrainedWidth(width: labelWidth, font: gothamFont)
        let textLayout:CGRect = CGRect.init(x: leftMargin+avatarSize+10, y: 20, width: labelWidth, height: labelHeight)
        detailText.frame = textLayout
        detailText.text = requestText!
        detailText.font = gothamFont
    }
    
    func getCellHeight(whom:String, service:String, type:NotificationType)->CGFloat{
        var requestText:String?
        switch type {
        case .request:
            requestText = whom + " has asked you for help with " + service
            break
        case .finish:
            requestText = whom + " has asked you for help with " + service
            break
        case .affirm:
            requestText = "Did " + whom + " finish helping you with " + service + "?"
            break
        default:
            //info
            requestText = whom + " accepted your request to help you with " + service
            break
        }
        let labelHeight = requestText?.heightWithConstrainedWidth(width: labelWidth, font: gothamFont)
        return (labelHeight! + 4 * topMargin) - defaultHeight > 0 ? labelHeight! + topMargin * 4 : defaultHeight
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
