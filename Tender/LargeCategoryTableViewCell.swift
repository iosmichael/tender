//
//  LargeCategoryTableViewCell.swift
//  Tender
//
//  Created by Michael Liu on 1/26/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class LargeCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func fillCell(icon:UIImage, title:String){
        self.icon.image = icon
        self.title.text = title
    }
    
    func getHeight() -> CGFloat{
        return 82
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
