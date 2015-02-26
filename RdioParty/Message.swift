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
    var messageId :String
//    var timestamp :NSDate
    var userKey :String!
    var type :String!
    
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
    
    init(fromSnapshot snapshot :FDataSnapshot) {
        self.type = snapshot.value.valueForKey("type") as! String
        
        if (self.type == "User") {
            if let text = snapshot.value.valueForKey("message") as? String {
                self.text = text
            }
            self.userKey = snapshot.value.valueForKey("userKey") as! String            
        }
        
        self.messageId = snapshot.value.valueForKey("id") as! String

        
        let dateFormatter = NSDateFormatter()
//        self.timestamp = dateFormatter.dateFromString(snapshot.value.timestamp)!

        
        super.init()
    }
    
}
