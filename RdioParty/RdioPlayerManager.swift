//
//  RdioManagr.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//

import UIKit

class RdioPlayerManager :NSObject, RdioDelegate, RDPlayerDelegate {
    var fireBaseRef :Firebase!
    var rdio: Rdio!
    
    override init() {
        self.rdio = Rdio(consumerKey: Credentials.RdioConsumerKey, andSecret: Credentials.RdioConsumerSecret, delegate: nil)
        
        super.init()
        self.rdio.delegate = self
        self.rdio.preparePlayerWithDelegate(self);
    }
    
    func updateForRoom(room :Room) {
        self.fireBaseRef =  Firebase(url:"https://rdioparty.firebaseio.com/\(room.name)/player")
        self.rdio.authorizeUsingAccessToken(UIApplication.rdioPartyApp.session.accessToken)

        // Track position
//        self.fireBaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
//            if let position: Double = snapshot.value as? Double {
//                if (self.rdio.player.state.value == RDPlayerStatePlaying.value) {
//                    if (abs(self.rdio.player.position - position) > 3) { // If we're more than 3 seconds out of sync from the party then resync.
//                        self.rdio.player.seekToPosition(position)
//                    }
//                }
//            }
//        });
        
        // Current song
        self.fireBaseRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value.valueForKey("playingTrack") != nil {
                
                if let track = snapshot.value as? NSDictionary {
                    let trackKey = snapshot.value.valueForKeyPath("playingTrack.trackKey") as! String
                    if (trackKey != self.rdio.player.currentTrack) {
                        self.rdio.player.play(trackKey)
                        
                        // So we don't have to make an additional API call let's see if we can find this track in the queue
                        var song = UIApplication.rdioPartyApp.session.room.queue.getSongById(trackKey)
                        if (song != nil) {
                            UIApplication.rdioPartyApp.session.currentSong = song!
                            UIApplication.rdioPartyApp.session.themeColor = song!.color!
                            UIApplication.rdioPartyApp.session.backgroundUrl = song!.backgroundImage
                        } else {
                            // Couldn't find the track.  Let's rebuild it.
                            var song = Song()
                            song.trackKey = trackKey
                            self.updateSongWithDetails(song, completionClosure: { () in
                                UIApplication.rdioPartyApp.session.currentSong = song
                                UIApplication.rdioPartyApp.session.themeColor = song.color!
                                UIApplication.rdioPartyApp.session.backgroundUrl = song.backgroundImage
                            });
                        }
                    }
                    
                    if (self.rdio.player.state.value == RDPlayerStatePlaying.value) {
                        let position = snapshot.value.valueForKey("position") as! Double
                        if (abs(self.rdio.player.position - position) > 3) { // If we're more than 3 seconds out of sync from the party then resync.
                            self.rdio.player.seekToPosition(position)
                        }
                    }

                    
                }
                

            }
        })
        
    }
    
    // MARK: - Track Details
    func updateSongWithDetails(song: Song, completionClosure: () ->()) {
        var parameters:Dictionary<NSObject, AnyObject!> = ["keys": song.trackKey, "extras": "-*,name,artist,dominantColor,duration,bigIcon,icon,playerBackgroundUrl"]
        
        self.rdio.callAPIMethod("get",
            withParameters: parameters,
            success: { (result) -> Void in
                let track: AnyObject? = result[song.trackKey]
                song.updateWithApiData(track! as! NSDictionary)
                completionClosure()
            }) { (error) -> Void in
                // Error
        }
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
    
    func rdioPlayerCurrentSourceDidChange() {
    }
    
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
