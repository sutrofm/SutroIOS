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
    var previewImage: NSURL!
    var previewPeopleCount = 0
    var active = false
    
    init(fromSnapshot snapshot :FDataSnapshot) {

        self.messages = Array<Message>()
        self.name = snapshot.key

        if (snapshot.value.objectForKey("meta") != nil) {
            let metaObject = snapshot.value.objectForKey("meta") as! NSObject
            self.theme = metaObject.valueForKey("themeText") as! String
        }
        
        // Messy way of determining if there are active people in this room.
        // Can't I just use a predicate or something?  It doesn't help that these
        // are non-swift objects either, I suppose.  Will get back to this.
        var peopleOnline = 0
        if ((snapshot.value.objectForKey("people") != nil)) {
            let peopleObject = snapshot.value.objectForKey("people") as! NSDictionary
            let peopleKeys = peopleObject.allKeys
            
            for key in peopleKeys {
                let person: NSDictionary? = peopleObject.objectForKey(key) as? NSDictionary
                if (person?.valueForKey("isOnline") as! Bool) {
                    peopleOnline++
                }
            }
            self.previewPeopleCount = peopleOnline
        }
        
        // If there are people in the room then let's get additional information.  Otherwise who cares.
        if (self.previewPeopleCount > 0) {
            
            // Is any audio playing?
            if ((snapshot.value.objectForKey("player") != nil)) {
                let playerObject = snapshot.value.objectForKey("player") as! NSObject
                self.active = playerObject.valueForKey("playState") as! Bool
            }

            // As a short-cut let's use any messages as a way to get an image.  Otherwise we'd have to ask for the queue.
            if (self.active && snapshot.value.objectForKey("messages") != nil) {
                let messagesObject = snapshot.value.objectForKey("messages") as! NSDictionary
                let messageKeys = messagesObject.allKeys
                
                for key in messageKeys {
                    let message: NSDictionary? = messagesObject.objectForKey(key) as? NSDictionary
                    if (message?.valueForKey("type") as! String == "NewTrack") {
                        var url = message?.valueForKey("iconUrl") as! String
                        self.previewImage = NSURL(string: url)!
                        break
                    }
                }
            }

            
            
        }
        

        
        
        super.init()

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
