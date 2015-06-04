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
    var songCache = NSCache()
    var userCache = NSCache()
    
    override init() {
        self.rdio = Rdio(consumerKey: Credentials.RdioClientId, andSecret: Credentials.RdioClientSecret, delegate: nil)
        
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
                            song!.userKey = snapshot.value.valueForKeyPath("playingTrack.userKey") as! String!
                            UIApplication.rdioPartyApp.session.currentSong = song!
                            UIApplication.rdioPartyApp.session.themeColor = song!.color!
                            UIApplication.rdioPartyApp.session.backgroundUrl = song!.backgroundImage
                        } else {
                            // Couldn't find the track.  Let's rebuild it.
                            self.getSongWithDetails(trackKey, completionClosure: { (newSong, cached) in
                                UIApplication.rdioPartyApp.session.currentSong = newSong
                                UIApplication.rdioPartyApp.session.themeColor = newSong.color!
                                UIApplication.rdioPartyApp.session.backgroundUrl = newSong.backgroundImage
                                newSong.userKey = snapshot.value.valueForKeyPath("playingTrack.userKey") as! String!
                            });
                        }
                    }
                    
                    if (self.rdio.player.state.value == RDPlayerStatePlaying.value) {
                        let position = snapshot.value.valueForKey("position") as! Double
                        if (abs(self.rdio.player.position - position) > 3) { // If we're more than 3 seconds out of sync from the party then resync.
                            self.rdio.player.seekToPosition(position + 1) // + 1 to compensate for the slight delay that a seek takes.
                        }
                    }

                    
                }
                

            }
        })
        
    }
    
    // MARK: - Track Details
    func getSongWithDetails(rdioid: String, completionClosure: (song :Song, cached :Bool) ->()) {
        
        if let song: Song = songCache.objectForKey(rdioid) as! Song? {
            completionClosure(song: song, cached: true)
            return
        }
        
        var parameters:Dictionary<NSObject, AnyObject!> = ["keys": rdioid, "extras": "-*,name,artist,dominantColor,duration,bigIcon,icon,playerBackgroundUrl,key"]
        
        self.rdio.callAPIMethod("get",
            withParameters: parameters,
            success: { (result) -> Void in
                let apiData: AnyObject? = result[rdioid]
                let song = Song()
                song.updateWithApiData(apiData as! NSDictionary!)
                self.songCache.setObject(song, forKey: rdioid)
                
                completionClosure(song: song, cached: false)
            }) { (error) -> Void in
                // Error
        }
    }
    
    // MARK: - User Details
    func getPersonWithDetails(rdioid: String, completionClosure: (person :Person) -> ()) {
        
        if let user: Person = userCache.objectForKey(rdioid) as! Person? {
            completionClosure(person: user)
            return
        }
        
        var parameters:Dictionary<NSObject, AnyObject!> = ["keys": rdioid, "extras": "-*,firstName,lastName,icon,key,icon250"]
        self.rdio.callAPIMethod("get",
            withParameters: parameters,
            success: { (result) -> Void in
                var updatedPerson = Person(fromRdioUser: result[rdioid] as! NSDictionary)
                self.userCache.setObject(updatedPerson, forKey: rdioid)
                
                completionClosure(person: updatedPerson)
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
