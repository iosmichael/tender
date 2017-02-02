//
//  ItemTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/23/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var provider: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(title:String, provider:String, labelDate:String, credit:String){
        self.title.text = title
        self.provider.text = "Provided by \(provider)"
        self.labelDate.text = labelDate
        self.credit.text = credit
    }
    
}
