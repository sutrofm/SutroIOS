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
        return self.songs.indexOf(song)
    }
    
    func removeSongById(id: String) {
        if let song = self.getSongById(id) {
            song.queued = false
        }
    }
    
    func sort() {
        self.allSongs = self.allSongs.sort({
            if $0.upVotes() != $1.upVotes() {
                return $0.upVotes() > $1.upVotes()
            } else if $0.downVotes() != $1.downVotes() {
                return $0.downVotes() < $1.downVotes()
            } else {
                return $0.timestampAdded.compare($1.timestampAdded) == .OrderedDescending
            }
            
        })
    }
    
    func count() -> Int {
        return self.songs.count
    }
    
    func songAtIndex(index: Int) -> Song {
        return self.songs[index]
    }
}