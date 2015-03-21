//
//  PartyPlayerManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/4/15.
//

import UIKit

class PartyPlayerManager: NSObject {
   
    var firebase :Firebase!
    var rdio :Rdio = UIApplication.rdioPartyApp.playerManager.rdio
    let userid = UIApplication.rdioPartyApp.session.user.rdioId
    
    convenience init(firebaseRef ref :Firebase) {
        self.init()
        self.firebase = ref
    }
    
    func addTrackToQueue(trackKey:String) {
        var postRef = firebase.childByAutoId()

        var track = ["trackKey": trackKey,
            "userKey" : userid,
            "votes" : [userid : "like"],
            "timestamp" : NSDate().formatted,
            "id" : postRef.key
        ]
        
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
    
    // Add to user's Rdio favorites.
    // TODO: This crashes.  I don't know why.  I think it's in the SDK.
    // Will have to look into it.
    func favoriteSong(song :Song, completionClosure: (success :Bool) ->()) {
        completionClosure(success: false)
//        var parameters:Dictionary<NSObject, AnyObject!> = ["keys": song.trackKey]
//
//        self.rdio.callAPIMethod("addToFavorites",
//            withParameters: parameters,
//            success: { (result) -> Void in
//                completionClosure(success: true)
//            }) { (error) -> Void in
//                completionClosure(success: false)
//        }
    }
}
