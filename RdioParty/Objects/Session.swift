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
    var autoQueueTracks :[String] = ["t36507856", "t19425252", "t1328012", "t1123066", "t28021873", "t8950690"] //Temporary
    
    override init() {
        super.init()
        self.rdio.delegate = self
    }

    var room: Room! {
        didSet {
            updatePlayer()
        }
    }
    
    var user: Person!
    var accessToken: String! {
        didSet {
            self.rdio.authorizeUsingAccessToken(accessToken)
            UIApplication.rdioPartyApp.playerManager.rdio.authorizeUsingAccessToken(accessToken)
        }
    }
    
    var firebaseAuthToken: String = "eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJkZWJ1ZyI6IHRydWUsICJpYXQiOiAxNDI2Mzk0ODY3LCAiZCI6IHsicmRpb191c2VyX2tleSI6ICJzNDA3NSJ9LCAidiI6IDB9.q78SUqT5a8n7RrTuRMpKvcw-z-N0wgtyTD2BBGMU_Rk"
    
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
    
    
    func updatePlayer() {
        UIApplication.rdioPartyApp.playerManager.updateForRoom(self.room)
    }
    
  }