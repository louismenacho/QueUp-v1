//
//  SearchViewModel.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/23/21.
//

import Foundation

class SearchViewModel: NSObject {
    
    var searchResult = [SearchResultItem]()
    
    private var spotifySearchAPI = SpotifyAPIClient<SpotifySearchAPI>()
    private var spotifyPlayerAPI = SpotifyAPIClient<SpotifyPlayerAPI>()
    
    init(_ spotifyToken: String) {
        spotifySearchAPI.auth = .bearer(token: spotifyToken)
        spotifyPlayerAPI.auth = .bearer(token: spotifyToken)
    }
    
    func updateSpotifyToken(_ token: String) {
        spotifySearchAPI.auth = .bearer(token: token)
        spotifyPlayerAPI.auth = .bearer(token: token)
    }
    
    func updateSearchResult(query: String, completion: @escaping (Result<Void, ClientError>) -> Void) {
        spotifySearchAPI.request(.search(query: query, type: "track", limit: 50)) { (result: Result<SearchResponse, ClientError>) in
            completion( result.flatMap { searchResult in
                self.searchResult = searchResult.tracks.items.map { SearchResultItem(from: $0) }
                return .success(())
            })
        }
    }
    
    func enqueueSong(at index: Int, completion: @escaping (Result<Song, ClientError>) -> Void) {
        searchResult[index].isAdded = true
        spotifyPlayerAPI.request(.queueTrack(uri: searchResult[index].song.spotifyURI)) { [self] (result: Result<EmptyData, ClientError>) in
            switch result {
            case .failure(let error):
                searchResult[index].isAdded = false
                completion(.failure(error))
            case .success:
                completion(.success(self.searchResult[index].song))
            }
        }
    }
}
