//
//  Person.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation
import SwiftyJSON

class Person: NSObject {
    
    var name :String
    var rdioId :String
    var icon :String
    var isOnline :Bool
    
    init(fromSnapshot snaphsot :NSObject) {
        self.name = snaphsot.valueForKey("fullName") as! String
        self.rdioId = snaphsot.valueForKey("id") as! String
        self.icon = snaphsot.valueForKey("icon") as! String
        self.isOnline = snaphsot.valueForKey("isOnline") as! Bool
        
        super.init()
    }
}
