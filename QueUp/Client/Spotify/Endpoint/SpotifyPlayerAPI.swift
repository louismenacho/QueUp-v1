//
//  SpotifyPlayerAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 3/18/21.
//

import Foundation

enum SpotifyPlayerAPI: SpotifyAPIEndpoint {
    case playerState
    case currentlyPlayingTrack
    case recentlyPlayedTracks(limit: Int)
    case startPlayback(uris: [String]? = nil, position: Int = 0)
    case pausePlayback
    case queueTrack(uri: String)
    case seek(position: Int)
    
    var request: APIRequest {
        var apiRequest = APIRequest(baseURL: "https://api.spotify.com/v1/me/player")
        
        switch self {
            case .playerState:
                apiRequest.method = .get

            case .currentlyPlayingTrack:
                apiRequest.method = .get
                apiRequest.path =   "/currently-playing"
                
            case .recentlyPlayedTracks(let limit):
                apiRequest.method = .get
                apiRequest.path =   "/recently-played"
                apiRequest.params = ["limit": limit]
                
            case .startPlayback(let uris, let position):
                apiRequest.method = .put
                apiRequest.path =   "/play"
                apiRequest.header = ["Content-Type": "application/json"]
                apiRequest.body =   uris == nil ? [:] : ["uris": uris!, "position_ms": position]
                
            case .pausePlayback:
                apiRequest.method = .put
                apiRequest.path =   "/pause"
                
            case .queueTrack(let uri):
                apiRequest.method = .post
                apiRequest.path =   "/queue"
                apiRequest.header = ["Content-Type": "application/json"]
                apiRequest.params =   ["uri": uri]
                
            case .seek(let position):
                apiRequest.method = .put
                apiRequest.path =   "/seek"
                apiRequest.params = ["position_ms": position]
        }
        
        return apiRequest
    }
    
}
