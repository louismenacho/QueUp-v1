//
//  SpotfiyRecommendationsAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 7/7/21.
//

import Foundation


enum SpotfiyRecommendationsAPI: SpotifyAPIEndpoint {
    case recommendations(limit: Int, seedTrackIDs: [String])
    
    var request: APIRequest {
        var apiRequest = APIRequest(baseURL: "https://api.spotify.com/v1/recommendations")
        
        switch self {
        case let .recommendations(limit, seedTrackIDs):
            apiRequest.method = .get
            apiRequest.params = [
                "limit": limit,
                "seed_tracks": seedTrackIDs.joined(separator: ",")
            ]
        }
        
        return apiRequest
    }
}
