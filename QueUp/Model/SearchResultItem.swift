//
//  SearchResultItem.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/26/21.
//

import Foundation

struct SearchResultItem {
    var song: Song
    var isAdded: Bool
    
    init() {
        song = Song()
        isAdded = false
    }
    
    init(from spotifyTrack: Track) {
        song = Song(from: spotifyTrack)
        isAdded = false
    }
}
