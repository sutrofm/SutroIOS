//
//  Queue.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit


class Queue: NSObject {

    var songs = Array<Song>()

    func add(song: Song) {
        songs.append(song)
        sort()
    }
    
    func getSongById(id: String) -> Song? {
        return self.songs.filter{ $0.trackKey == id }.first
    }
    
    func getIndexForSong(song: Song) -> Int? {
        return find(self.songs, song)
    }
    
    func removeSongById(id: String) {
        if let song = self.getSongById(id) {
            let index = self.getIndexForSong(song)
            self.songs.removeAtIndex(index!)
        }
    }
    
    func sort() {
        self.songs.sort({ $0.upVoteKeys.count > $1.upVoteKeys.count })
    }
    
    func count() -> Int {
        return self.songs.count
    }
    
    func songAtIndex(index: Int) -> Song {
        return self.songs[index]
    }
}
