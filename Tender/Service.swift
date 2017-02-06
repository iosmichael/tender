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
    var providerEmail:String?
    var uid:String?
    var title:String?
    var skills:[String]?
    var category:String?
    var credits:String?
    var date:String?
    var thumbnail:String?
    var id:String?
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
    
    func convertMessageDatetoString(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter.string(from: date)
    }
    
    func convertMessageStringtoDate(input:String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter.date(from: input)!
    }
    
}
