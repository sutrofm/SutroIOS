//
//  ConnectionManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
//import Starscream
//import SwiftyJSON

class ConnectionManager : NSObject {
    
//    var firebase: Firebase
//    var socket: WebSocket
    var room: Room!
    
    // Singleton
    class var sharedInstance: ConnectionManager {
        struct Static {
            static var instance: ConnectionManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ConnectionManager()
        }
        
        return Static.instance!
    }
    
    
    override init() {
        super.init()
    }
    
    
    
    func joinRoom(room: Room) {
        self.room = room;
    }
    
  }