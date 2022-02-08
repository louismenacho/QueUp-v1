//
//  SpotifyUserProfileAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 9/2/21.
//

import Foundation

enum SpotifyUserProfileAPI: SpotifyAPIEndpoint {
    case currentUserProfile
    
    var request: APIRequest {
        var apiRequest = APIRequest(baseURL: "https://api.spotify.com/v1")
        
        switch self {
            case .currentUserProfile:
                apiRequest.method = .get
                apiRequest.path = "/me"
        }
        
        return apiRequest
    }
}
