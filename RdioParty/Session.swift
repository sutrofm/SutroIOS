//
//  Session.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//

import UIKit

class Session : NSObject {

    var fireBaseRef :Firebase!

    var room: Room! {
        didSet {
            self.fireBaseRef =  Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/player")
            monitorPlayer()
        }
    }
    
    var user: [NSObject : AnyObject]!
    var accessToken: String!
    var themeColor :UIColor!
    
    // Singleton
    class var sharedInstance: Session {
        struct Static {
            static var instance: Session?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Session()
        }
        
        return Static.instance!
    }
    
    
    override init() {
        super.init()
    }
    
    func monitorPlayer() {
        
    }
    
  }