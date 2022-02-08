//
//  SpotifySearchAPI.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/12/21.
//

import Foundation

enum SpotifySearchAPI: SpotifyAPIEndpoint {
    case search(query: String, type: String, limit: Int)
    
    var request: APIRequest {
        var apiRequest = APIRequest(baseURL: "https://api.spotify.com/v1/search")
        
        switch self {
        case let .search(query, type, limit):
            apiRequest.method = .get
            apiRequest.params = [
                "q": query,
                "type": type,
                "limit": "\(limit)"
            ]
        }
        
        return apiRequest
    }
}
