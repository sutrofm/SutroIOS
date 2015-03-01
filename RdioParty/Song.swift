//
//  Song.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class Song: NSObject {
    var upVoteKeys = Array<String>()
    var downVoteKeys = Array<String>()
    
    var trackKey :String!
    var partyId :String!
    var icon :String!
    var bigIcon :String!
    var backgroundImage :String!
    var artistName :String!
    var trackName :String!
    
    init(fromSnapshot snapshot :FDataSnapshot) {
        self.trackKey = snapshot.value.valueForKey("trackKey") as! String
        self.partyId = snapshot.key
        
        let votes = snapshot.value.objectForKey("votes") as! NSDictionary
        for vote in votes {
            let type = vote.value as! String
            let user = vote.key as! String
            
            if (type == "like") {
                self.upVoteKeys.append(user)
            } else {
                self.downVoteKeys.append(user)
            }
        }
        
        super.init()
    }
}