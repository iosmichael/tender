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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(profile:String, email:String){
        self.profileName.text = profile
        self.email.text = email
    }
}
