//
//  Transaction.swift
//  Tender
//
//  Created by Michael Liu on 1/27/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

class Transaction: NSObject {
    var id: String = ""
    var state:String = "request"
    var service:String = ""
    var serviceId:String = ""
    var user:String = ""
    var isProvider:Bool = false
    var date:String = ""
    var credit:String = ""
}
