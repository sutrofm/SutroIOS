//
//  PartyPlayerManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/4/15.
//

import UIKit

class PartyPlayerManager: NSObject {
   
    var firebaseRef :Firebase!
    let userid = UIApplication.rdioPartyApp.session.user.rdioId
    
    convenience init(firebaseRef ref :Firebase) {
        self.init()
        self.firebaseRef = ref
    }
    
    func addTrackToQueue(trackKey:String) {
        var track = ["trackKey": trackKey, "userKey" : userid, "votes" : [userid : "like"]]
        var postRef = self.firebaseRef.childByAutoId()
        postRef.setValue(track)
    }
    
    func voteDownSong(song :Song) {
        
    }
    
    func voteUpSong(song :Song) {
        
    }
    
    func skipCurrentSong(song :Song) {
        
    }
    
    func favoriteSong(song :Song) {
        
    }
    
    
    
}
