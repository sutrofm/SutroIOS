//
//  Message.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MessageType {
    case User, NewTrack
}

class Message: NSObject {
    var text :String!
//    var messageId :String
//    var timestamp :NSDate
//    var person :Person!

//    class func createArray(jsonMessages: JSON) -> Array<Message> {
//        var messages = Array<Message>()
//        
//        for (key: String, subJson: JSON) in jsonMessages {
//            var message = Message(fromJson: subJson)
//            messages.append(message)
//        }
//        
//        return messages
//    }
    
    init(fromSnapshot snapshot :NSObject) {
        super.init()

        if let text: AnyObject = snapshot.valueForKey("message") {
            self.text = text as! String
        }
//        self.messageId = snapshot.valueForKey("id") as! String
        
//        self.text = json["message"].stringValue
//        self.messageId = json["id"].stringValue
//        
//        let dateFormatter = NSDateFormatter()
//        self.timestamp = dateFormatter.dateFromString(json["timestamp"].stringValue)!
        
//        if let singlePerson = ConnectionManager.sharedInstance.room.getUser(json["userKey"].stringValue) {
//            self.person = singlePerson
//        }
        
    }
    
}
