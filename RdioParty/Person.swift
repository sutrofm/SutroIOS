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
    var icon :NSURL
    var isOnline :Bool
    
    class func createArray(jsonPeople: JSON) -> Array<Person> {
        var people = Array<Person>()
        
        for (key: String, subJson: JSON) in jsonPeople {
            var person = Person(fromJson: subJson)
            //if (person.isOnline) {
                people.append(person)
            //}
        }
        
        return people
    }
    
    init(fromJson json :JSON) {
        self.name = json["fullName"].stringValue
        self.rdioId = json["id"].stringValue
        self.icon = json["icon"].URL!
        self.isOnline = json["isOnline"].boolValue
        
        super.init()
    }
}
