//
//  Service.swift
//  Tender
//
//  Created by Michael Liu on 1/28/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class Service: NSObject {
    var provider:String?
    var title:String?
    var skills:[String]?
    var category:String?
    var credits:String?
    var date:String?
}

extension NSObject{
    
    func convertDatetoString(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func convertStringtoDate(input:String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: input)!
    }
    
}
