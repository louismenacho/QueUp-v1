//
//  SpotifyAccountsAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/30/21.
//

import Foundation

enum SpotifyAccountsAPI: SpotifyAPIEndpoint {
    case apiToken
    
    var request: APIRequest {
        var apiRequest = APIRequest(baseURL: "https://accounts.spotify.com")
        
        switch self {
        case .apiToken:
            apiRequest.method = .post
            apiRequest.path =   "/api/token"
            apiRequest.header = ["Content-Type": "application/x-www-form-urlencoded"]
            apiRequest.body =   ["grant_type": "client_credentials"]
        }
        
        return apiRequest
    }
}
