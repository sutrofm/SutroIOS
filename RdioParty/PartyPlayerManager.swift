//
//  PartyPlayerManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/4/15.
//

import UIKit

class PartyPlayerManager: NSObject {
   
    var firebase :Firebase!
    var rdio :Rdio!
    let userid = UIApplication.rdioPartyApp.session.user.rdioId
    
    convenience init(firebaseRef ref :Firebase) {
        self.init()
        self.firebase = ref
    }
    
    func addTrackToQueue(trackKey:String) {
        var track = ["trackKey": trackKey, "userKey" : userid, "votes" : [userid : "like"]]
        var postRef = firebase.childByAutoId()
        postRef.setValue(track)
    }

    func voteDownSong(song :Song) {
        let postRef = firebase.childByAutoId()
        let post = ["trackKey": song.trackKey, "userKey": userid, "votes" : [userid : "dislike"]]
        postRef.setValue(post)
    }
    
    func voteUpSong(song :Song) {
        let postRef = firebase.childByAutoId()
        let post = ["trackKey": song.trackKey, "userKey": userid, "votes" : [userid : "like"]]
        postRef.setValue(post)
    }
    
    // Need to find the actual syntax of the object to send for this.
    func skipCurrentSong(song :Song) {

    }
    
    // Add to user's Rdio favorites
    func favoriteSong(song :Song) {
        
    }
    
    
    
}
