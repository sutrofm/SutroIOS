//
//  Session.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//

import UIKit

class Session : NSObject, RdioDelegate {

    // A shared rdio instance for making API calls.  The player manager has its
    // own for audio playback.  I don't like this but the player manager needs
    // all the delegate callbacks.  Could probably abstract this instance elsewhere.
    var rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)

    override init() {
        super.init()
        self.rdio.delegate = self
    }
    
    var room: Room! {
        didSet {
            updatePlayer()
        }
    }
    
    let playerManager = RdioPlayerManager()
    var user: [NSObject : AnyObject]!
    var accessToken: String! {
        didSet {
            self.rdio.authorizeUsingAccessToken(accessToken)
            self.playerManager.rdio.authorizeUsingAccessToken(accessToken)
        }
    }
    
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
    
    func updatePlayer() {
        playerManager.updateForRoom(self.room)
    }
    
  }