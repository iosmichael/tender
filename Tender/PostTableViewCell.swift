//
//  PostTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

protocol PostCellProtocol {
    func addBtn(label:String)
    func deleteBtn(cell:PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var delegate: PostCellProtocol?
    
    let gothamMediumExtraLarge = UIFont.init(name: "Gotham-Medium", size: 40)
    let gothamMediumLargeFont = UIFont.init(name: "Gotham-Medium", size: 22)
    let gothamMediumFont = UIFont.init(name: "Gotham-Medium", size: 18)
    let gothamBookFont = UIFont.init(name: "Gotham-Book", size: 15)
    
    let leftMargin:CGFloat = 20
    let topMargin:CGFloat = 5
    let bottomMargin:CGFloat = 15
    let screenWidth:CGFloat = UIScreen.main.bounds.width
    //big plus sign
    let largeSquare:CGFloat = 30
    //small plus sign
    let smallSquare:CGFloat = 22
    
    //basic components of cell dynamics
    var inputText:UITextField = UITextField()
    var labelText:UILabel = UILabel()
    var imageButton:UIButton = UIButton()
    var textButton:UIButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //set subviews
        self.contentView.addSubview(inputText)
        self.contentView.addSubview(labelText)
        self.contentView.addSubview(imageButton)
        self.contentView.addSubview(textButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func credits(inputStr:String){
        //credits layout: One Button, One Image Button
        //left imgBtn layout
        let imgBtn:CGRect = CGRect.init(x: leftMargin, y: topMargin, width: largeSquare, height: largeSquare)
        //right btn layout
        let textBtn:CGRect = CGRect.init(x: leftMargin+largeSquare+10, y: topMargin, width: 100, height: largeSquare)
        //imageBtn Settings
        imageButton.frame = imgBtn
        imageButton.setImage(UIImage.init(named: "bigPlus"), for: .normal)
        imageButton.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        //textBtn Settings
        textButton.frame = textBtn
        textButton.titleLabel?.textAlignment = .left
        textButton.titleLabel?.font = gothamMediumExtraLarge
        textButton.setTitle(inputStr, for: .normal)
        textButton.addTarget(self, action: #selector(addClick), for: .touchUpInside)
        setNeedsLayout()
    }
    
    func getCreditHeight()->CGFloat{
        return 2*topMargin+largeSquare
    }
    
    func inputField(labelStr:String){
        let textLayout:CGRect = CGRect.init(x: leftMargin-3, y: topMargin, width: screenWidth-2*leftMargin, height: 25)
        inputText.frame = textLayout
        inputText.font = gothamMediumLargeFont
        inputText.placeholder = labelStr
        setNeedsLayout()
    }
    
    func getinputHeight()->CGFloat{
        return 2*topMargin+25
    }
    
    func textField(labelStr:String){
        let textLayout:CGRect = CGRect.init(x: leftMargin, y: topMargin, width: screenWidth-2*leftMargin, height: 25)
        textLabel?.frame = textLayout
        textLabel?.font = gothamMediumLargeFont
        textLabel?.text = labelStr
        setNeedsLayout()
    }
    
    func gettextFieldHeight()->CGFloat{
        return 2*topMargin+25
    }
    
    func headerText(labelStr:String){
        //textfield indicates cell header
        let headerLayout:CGRect = CGRect.init(x: leftMargin, y: topMargin+20, width: screenWidth-2*leftMargin, height: 20)
        textLabel?.frame = headerLayout
        textLabel?.font = gothamBookFont
        textLabel?.text = labelStr
        setNeedsLayout()
    }
    
    func getHeaderHeight()->CGFloat{
        return topMargin+10+20
    }
    
    func skillsetAdd(labelStr:String){
        //skill set add: Textfield, Add Button
        let imgBtn:CGRect = CGRect.init(x: leftMargin, y: topMargin, width: smallSquare, height: smallSquare)
        let textBtn:CGRect = CGRect.init(x: leftMargin+smallSquare+10, y: topMargin, width: screenWidth-2*leftMargin-smallSquare-10, height: smallSquare)
        //Settings
        imageButton.frame = imgBtn
        imageButton.setImage(UIImage.init(named: "plus"), for: .normal)
        //add image Btn action
        inputText.frame = textBtn
        inputText.font = gothamMediumFont
        inputText.placeholder = labelStr
        setNeedsLayout()
    }
    
    func skillsetDelete(labelStr: String){
        //skill set add: Textfield, Add Button
        let imgBtn:CGRect = CGRect.init(x: leftMargin, y: topMargin, width: smallSquare, height: smallSquare)
        let textBtn:CGRect = CGRect.init(x: leftMargin+smallSquare+10, y: topMargin, width: screenWidth-2*leftMargin-smallSquare-10, height: smallSquare)
        //Settings
        imageButton.frame = imgBtn
        imageButton.setImage(UIImage.init(named: "minus"), for: .normal)
        //add image Btn action
        textLabel?.frame = textBtn
        textLabel?.font = gothamMediumFont
        textLabel?.text = labelStr
        setNeedsLayout()
    }
    
    func skillset(labelStr:String){
        let textBtn:CGRect = CGRect.init(x: leftMargin, y: topMargin, width: screenWidth-2*leftMargin, height: smallSquare)
        textLabel?.frame = textBtn
        textLabel?.font = gothamMediumFont
        textLabel?.text = "- "+labelStr
        setNeedsLayout()
    }
    
    func getSkillsetHeight()->CGFloat{
        return 2*topMargin + smallSquare + 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addClick(){
        if ((inputText.text?.isEmpty)!){
            return
        }
        delegate?.addBtn(label:inputText.text!)
    }
    
    func deleteClick(){
        delegate?.deleteBtn(cell: self)
    }

}
