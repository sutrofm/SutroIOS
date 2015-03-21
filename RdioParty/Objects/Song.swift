//
//  Song.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//

import UIKit

class Song: NSObject {
    var upVoteKeys = Array<String>()
    var downVoteKeys = Array<String>()
    
    var trackKey :String!
    var userKey :String!
    var partyId :String!
    var icon :String!
    var bigIcon :String!
    var backgroundImage :NSURL!
    var artistName :String!
    var trackName :String!
    var color :UIColor!
    var timestampAdded :NSDate!
    var duration :Int!
    var queued = true
    var favorite = false
    
    override init () {
        super.init()
    }
    
    init(fromSnapshot snapshot :FDataSnapshot) {
        if let timestamp = NSDate.fromTimestamp(snapshot.value.valueForKey("timestamp") as! String) {
            self.timestampAdded = timestamp
        }
        self.trackKey = snapshot.value.valueForKey("trackKey") as! String
        self.partyId = snapshot.key
        self.userKey = snapshot.value.valueForKey("userKey") as! String
        
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
    
    func updateWithApiData(apiData :NSDictionary) {
        self.icon = apiData["icon"] as! String!
        self.bigIcon = apiData["bigIcon"] as! String!
        self.artistName = apiData["artist"] as! String!
        self.trackName = apiData["name"] as! String!
        self.backgroundImage = NSURL(string: apiData["playerBackgroundUrl"] as! String)
        self.duration = apiData["duration"] as! Int!
        self.trackKey = apiData["key"] as! String!
        
        let colorData = apiData["dominantColor"] as! Dictionary<String, CGFloat>
        let red = colorData["r"]! / 255.0
        let green = colorData["g"]! / 255.0
        let blue = colorData["b"]! / 255.0
        let alpha = colorData["a"]! / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        self.color = color
        
        self.timestampAdded = NSDate()
    }
    
    func upVotes() -> Int {
        return self.upVoteKeys.count
    }
    
    func downVotes() -> Int {
        return self.downVoteKeys.count
    }
}