//
//  Room.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import SwiftyJSON

class Room: NSObject {
    var name: String!
    var theme: String!
    
    var messages: Array<Message>
    var people: Array<Person>!
    var previewImage: NSURL = NSURL(string: "http://www.philcollins-fr.com/Genesis/albums/17dance.jpg")!
    
    init(fromName name :String) {
        self.messages = Array<Message>()
        
        super.init()
        self.name = name
    }
    
    func populatePeople(roomPeople :Array<Person>) {
        self.people = roomPeople
    }
    
    func updateMessages(jsonMessages :JSON) {
        //self.messages = Message.createArray(jsonMessages)
    }
    
    func getUser(rdioId :String) -> Person? {
        let singlePerson = people.filter{ $0.rdioId == rdioId }.first
        return singlePerson
    }
}
