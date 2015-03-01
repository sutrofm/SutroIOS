//
//  Session.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//

import UIKit

class Session : NSObject {

    var room: Room! {
        didSet {
            updatePlayer()
        }
    }
    
    let playerManager = RdioPlayerManager()
    var user: [NSObject : AnyObject]!
    var accessToken: String!
    
    var themeColor :UIColor! {
        didSet {
            // Send out notification to let others know to refresh this
            NSNotificationCenter.defaultCenter().postNotificationName("themeColorChanged", object: nil)
        }
    }
    
    var backgroundUrl :NSURL! {
        didSet {
            // Send out notification to let others know to refresh this
            NSNotificationCenter.defaultCenter().postNotificationName("themeBackgroundChanged", object: nil)
        }
    }
    
    var currentSong :Song! {
        didSet {
            // Send out notification to let others know to refresh current song data
            NSNotificationCenter.defaultCenter().postNotificationName("currentSongChanged", object: nil)
        }
    }
    
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
    
    func updatePlayer() {
        playerManager.updateForRoom(self.room)
    }
    
  }