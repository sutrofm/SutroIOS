//
//  PartyPlayerManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/4/15.
//

import UIKit

class PartyPlayerManager: NSObject {
   
    var firebaseRef :Firebase!

    convenience init(firebaseRef ref :Firebase) {
        self.init()
        self.firebaseRef = ref
    }
    
    func addTrackToQueue(song: Song) {
        
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
