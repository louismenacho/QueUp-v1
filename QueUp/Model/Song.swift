//
//  Song.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/26/21.
//

import Foundation

struct Song: Codable {
    typealias MilliSeconds = Int

    var name: String
    var artist: String
    var album: String
    var artworkURL: String
    var duration: MilliSeconds
    var spotifyURI: String = ""
    
    init() {
        name = ""
        artist = ""
        album = ""
        artworkURL = ""
        duration = 0
    }
    
    init(from spotifyTrack: Track) {
        name = spotifyTrack.name
        artist = spotifyTrack.artists.map { $0.name }.joined(separator: ", ")
        album = spotifyTrack.album.name
        artworkURL = spotifyTrack.album.images.isEmpty ? "" : spotifyTrack.album.images[0].url
        duration = spotifyTrack.durationMS
        spotifyURI = spotifyTrack.uri
    }
}
