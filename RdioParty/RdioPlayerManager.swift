//
//  RdioManagr.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class RdioPlayerManager :NSObject, RdioDelegate, RDPlayerDelegate {
    var fireBaseRef :Firebase!

    // Singleton
    class var sharedInstance: RdioPlayerManager {
        struct Static {
            static var instance: RdioPlayerManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = RdioPlayerManager()
        }
        
        return Static.instance!
    }

    func updateForRoom(room :Room) {
        self.fireBaseRef =  Firebase(url:"https://rdioparty.firebaseio.com/\(room.name)/player")
        
        // Current song
        fireBaseRef!.observeEventType(.ChildAdded, withBlock: { snapshot in
            println(snapshot.value)
            if let track = snapshot.value as? NSDictionary {
                let trackKey = snapshot.value.valueForKey("trackKey") as! String
                self.rdio.player.play(trackKey)
                
                var song = Session.sharedInstance.room.queue.getSongById(trackKey)
                Session.sharedInstance.themeColor = song!.color!
                Session.sharedInstance.backgroundUrl = song!.backgroundImage
            }
            
        })
        
        // Track position
        fireBaseRef!.observeEventType(.ChildChanged, withBlock: { snapshot in
            println(snapshot.value)
            if (self.rdio.player.state.value == RDPlayerStatePlaying.value) {
                if let position = snapshot.value as? Double {
                    self.rdio.player.seekToPosition(position)
                }
            }
            
        })
        
    }
    
    var rdio: Rdio

    override init() {
        self.rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)

        super.init()
        self.rdio.delegate = self
        self.rdio.preparePlayerWithDelegate(self);
    }
    
    func rdioRequest(request: RDAPIRequest!, didLoadData data: AnyObject!) {
        println(data)
    }
    
    func rdioRequest(request: RDAPIRequest!, didFailWithError error: NSError!) {
        println(error)
    }
    
    // MARK: - RdioDelegate
    
    func rdioDidAuthorizeUser(user: [NSObject : AnyObject]!, withAccessToken accessToken: String!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(accessToken, forKey: "rdioAccessToken")
    }
    
    func rdioAuthorizationFailed(error: NSError!) {
        println("Rdio authorization failed with error: \(error.localizedDescription)")
    }
    
    func rdioAuthorizationCancelled() {
        println("rdioAuthorizationCancelled")
    }
    
    func rdioDidLogout() {
    }
        
    // MARK: - RDPlayerDelegate
    
    func rdioIsPlayingElsewhere() -> Bool {
        // Let the Rdio framework tell the user
        return false
    }
    
    
    func rdioPlayerFailedDuringTrack(trackKey: String!, withError error: NSError!) -> Bool {
        println("Rdio failed to play track %@\n%@ \(trackKey, error)")
        return false
    }
    
    func rdioPlayerQueueDidChange() {
    }
    
    func rdioPlayerChangedFromState(oldState: RDPlayerState, toState newState: RDPlayerState) {
        
    }

}
