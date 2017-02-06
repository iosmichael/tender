//
//  ProfileTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/24/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileName.font = UIFont.init(name: "Seravek-Bold", size: 18)
        email.font = UIFont.init(name: "Seravek-ExtraLight", size: 15)
        thumbnail.layer.cornerRadius = 35/2
        thumbnail.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(profile:String, email:String){
        self.profileName.text = profile
        self.email.text = email
    }
    
    func fillCellWithThumbnail(profile:String, email:String, thumbnailUrl:String){
        self.profileName.text = profile
        self.email.text = email
        self.thumbnail.downloadedFrom(link: thumbnailUrl)
    }
}
