//
//  Message.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

enum MessageType {
    case User, NewTrack, UserAction
}

class Message: NSObject {
    var text :String!
    var messageId :String!
    var timestamp :NSDate!
    var userKey :String!
    var type :MessageType!
    
    // New track message specifics
    var trackTitle :String!
    var trackImage :String!
    var trackArtist :String!
    var trackKey :String!

    init(fromSnapshot snapshot :FDataSnapshot) {
        super.init()

        var typeString = snapshot.value.valueForKey("type") as! String
        
        // Type
        var trackTypeMessageStrings = ["favorited this track", "voted to skip", "unfavorited this track"]
        if (typeString == "User") {
            self.type = .User
        } else if (typeString == "NewTrack") {
            self.type = .NewTrack
        }
        
        // Message text
        if let text = snapshot.value.valueForKey("message") as? String {
            self.text = text
        }
        
        if (self.type == MessageType.User && contains(trackTypeMessageStrings, self.text.lowercaseString)) {
            self.type = .UserAction
        }
        
        // User
        if let userKey = snapshot.value.valueForKey("userKey") as? String {
            self.userKey = userKey
        }
        
        
        // ID
        if let messageId = snapshot.value.valueForKey("id") as? String {
            self.messageId = messageId
        }
        
        // Track message specifics
        if (self.type == .NewTrack) {
            self.trackTitle = snapshot.value.valueForKey("title") as? String
            self.trackArtist = snapshot.value.valueForKey("artist") as? String
            self.trackImage = snapshot.value.valueForKey("iconUrl") as? String
            self.trackKey = snapshot.value.valueForKey("trackKey") as? String
        }
        
        // Timestamp
        if let timeStampString = snapshot.value.valueForKey("timestamp") as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
            if let date = dateFormatter.dateFromString(timeStampString) {
                self.timestamp = date
            }
        }
        
    }
    
}
