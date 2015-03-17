//
//  Queue.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//

import UIKit


class Queue: NSObject {

    var allSongs = Array<Song>()
    var songs :Array<Song> {
        return self.allSongs.filter{ $0.queued == true }
    }
    
    func add(song: Song) {
        self.allSongs.append(song)
        sort()
    }
    
    func getSongById(id: String) -> Song? {
        return self.allSongs.filter{ $0.trackKey == id }.first
    }
    
    func getIndexForSong(song: Song) -> Int? {
        return find(self.songs, song)
    }
    
    func removeSongById(id: String) {
        if let song = self.getSongById(id) {
            song.queued = false
        }
    }
    
    func sort() {
        self.allSongs.sort({ $0.upVoteKeys.count > $1.upVoteKeys.count })
    }
    
    func count() -> Int {
        return self.songs.count
    }
    
    func songAtIndex(index: Int) -> Song {
        return self.songs[index]
    }
}
