//
//  Person.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import Foundation

class Person: NSObject {
    
    var name :String!
    var rdioId :String
    var icon :String
    var isOnline :Bool
    
    init(fromSnapshot snaphsot :FDataSnapshot) {
        self.name = snaphsot.value.valueForKey("fullName") as! String
        self.rdioId = snaphsot.value.valueForKey("id") as! String
        self.icon = snaphsot.value.valueForKey("icon") as! String
        self.isOnline = snaphsot.value.valueForKey("isOnline") as! Bool
        
        super.init()
    }
    
    init(fromDictionary dictionary :NSDictionary) {
        
        // Because some users don't have names for some reason?
        if (dictionary.valueForKey("fullName") != nil) {
            self.name = dictionary.valueForKey("fullName") as! String
        }
        
        self.rdioId = dictionary.valueForKey("id") as! String
        self.icon = dictionary.valueForKey("icon") as! String
        self.isOnline = dictionary.valueForKey("isOnline") as! Bool
        
        super.init()
    }
}
