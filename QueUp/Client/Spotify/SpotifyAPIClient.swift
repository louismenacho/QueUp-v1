//
//  SpotifyAPIClient.swift
//  TurnTune
//
//  Created by Louis Menacho on 6/18/21.
//

import Foundation

class SpotifyAPIClient<Endpoint: SpotifyAPIEndpoint>: APIClient {
    var auth: HTTPAuthorization = .none
    
    init(auth: HTTPAuthorization = .none) {
        self.auth = auth
    }
}
