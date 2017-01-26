//
//  ItemTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var labelTag: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelCredit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelCredit.layer.cornerRadius = 5
        self.labelTag.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
