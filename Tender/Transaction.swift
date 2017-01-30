//
//  Transaction.swift
//  Tender
//
//  Created by Michael Liu on 1/27/17.
//  Copyright © 2017 Tender llc. All rights reserved.
//

import UIKit

enum TransactionState {
    case request
    case pending
    case affirm
    case complete
}

class Transaction: NSObject {
    var state:String = ""
    var service:String = ""
    var serviceId:String = ""
    var user:String = ""
    var provider:String = ""
    var date:String = ""
    var credit:String = ""
}
