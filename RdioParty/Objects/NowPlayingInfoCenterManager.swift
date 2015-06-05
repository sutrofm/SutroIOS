//
//  NowPlayingInfoCenterManager.swift
//  sutrofm
//
//  Created by Gabe Kangas on 6/5/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingInfoCenterManager: NSObject {
    let nowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
    
    required override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
    }
    
    func currentSongChanged() {
        if let song = UIApplication.rdioPartyApp.session.currentSong {
            var nowPlayingInfo :NSMutableDictionary = [
                MPMediaItemPropertyArtist: song.artistName,
                MPMediaItemPropertyTitle: song.trackName
            ]
            SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string:song.icon), options: SDWebImageOptions.LowPriority, progress: nil, completed: { (image, error, cachetype, finished, url) -> Void in
                if (image != nil) {
                    let artwork = MPMediaItemArtwork(image: image)
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                }
                self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo as [NSObject : AnyObject]
            })
        }
    }
}
