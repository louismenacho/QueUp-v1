//
//  SpotifyReponseModels.swift
//  TurnTune
//
//  Created by Louis Menacho on 7/15/21.
//

import Foundation

struct TokenResponse: Codable {
    var accessToken: String
    var tokenType: String
    var expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct SearchResponse: Codable {
    var tracks: Tracks
}

// MARK: - Tracks
struct Tracks: Codable {
    var href: String?
    var items: [Track]
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: JSONNull?
    var total: Int?
}

//// MARK: - TrackItem
//struct TrackItem: Codable {
//    var album: Album
//    var artists: [Artist]
//    var availableMarkets: [String]?
//    var discNumber, durationMS: Int
//    var explicit: Bool?
//    var externalIDS: ExternalIDS?
//    var externalUrls: ExternalUrls?
//    var href: String?
//    var id: String
//    var isLocal: Bool?
//    var name: String
//    var popularity: Int?
//    var previewURL: String?
//    var trackNumber: Int?
//    var type: String?
//    var uri: String?
//
//    enum CodingKeys: String, CodingKey {
//        case album, artists
//        case availableMarkets = "available_markets"
//        case discNumber = "disc_number"
//        case durationMS = "duration_ms"
//        case explicit
//        case externalIDS = "external_ids"
//        case externalUrls = "external_urls"
//        case href, id
//        case isLocal = "is_local"
//        case name, popularity
//        case previewURL = "preview_url"
//        case trackNumber = "track_number"
//        case type, uri
//    }
//}

// MARK: - Album
struct Album: Codable {
    var albumType: String?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [Image]
    var name: String
    var releaseDate: String?
    var releaseDatePrecision: String?
    var totalTracks: Int?
    var type: String?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: - Artist
struct Artist: Codable {
    var externalUrls: ExternalUrls?
    var href: String?
    var id, name: String
    var type: String?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    var spotify: String?
}

// MARK: - Image
struct Image: Codable {
    var height: Int?
    var url: String
    var width: Int?
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    var isrc: String?
}

// MARK: - CurrentlyPlayingResponse
struct CurrentlyPlayingResponse: Codable {
    var isPlaying: Bool?
    var currentlyPlayingType: String?
    var context: JSONNull?
    var progressMS: Int?
    var timestamp: Int?
    var item: Track?
    var actions: Actions?

    enum CodingKeys: String, CodingKey {
        case isPlaying = "is_playing"
        case currentlyPlayingType = "currently_playing_type"
        case context = "context"
        case progressMS = "progress_ms"
        case timestamp = "timestamp"
        case item = "item"
        case actions = "actions"
    }
}

// MARK: - Actions
struct Actions: Codable {
    var disallows: Disallows?

    enum CodingKeys: String, CodingKey {
        case disallows = "disallows"
    }
}

// MARK: - Disallows
struct Disallows: Codable {
    var togglingRepeatTrack: Bool?
    var skippingPrev: Bool?
    var pausing: Bool?
    var togglingShuffle: Bool?
    var togglingRepeatContext: Bool?

    enum CodingKeys: String, CodingKey {
        case togglingRepeatTrack = "toggling_repeat_track"
        case skippingPrev = "skipping_prev"
        case pausing = "pausing"
        case togglingShuffle = "toggling_shuffle"
        case togglingRepeatContext = "toggling_repeat_context"
    }
}

// MARK: - RecentlyPlayedResponse
struct RecentlyPlayedResponse: Codable {
    var items: [Track]
    var next: String?
    var cursors: Cursors?
    var limit: Int?
    var href: String?
}

enum CodingKeys: String, CodingKey {
    case items = "items"
    case next = "next"
    case cursors = "cursors"
    case limit = "limit"
    case href = "href"
}

// MARK: - Cursors
struct Cursors: Codable {
    var after: String?
    var before: String?

    enum CodingKeys: String, CodingKey {
        case after = "after"
        case before = "before"
    }
}

// MARK: - Context
struct Context: Codable {
    var externalUrls: ExternalUrls?
    var href: String?
    var type: String?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href = "href"
        case type = "type"
        case uri = "uri"
    }
}

// MARK: - Track
struct Track: Codable {
    var album: Album
    var artists: [Artist]
    var availableMarkets: [String]?
    var discNumber: Int?
    var durationMS: Int
    var explicit: Bool?
    var externalIDS: ExternalIDS?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String
    var isLocal: Bool?
    var name: String
    var popularity: Int?
    var previewURL: String?
    var trackNumber: Int?
    var type: String?
    var uri: String

    enum CodingKeys: String, CodingKey {
        case album = "album"
        case artists = "artists"
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit = "explicit"
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href = "href"
        case id = "id"
        case isLocal = "is_local"
        case name = "name"
        case popularity = "popularity"
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type = "type"
        case uri = "uri"
    }
}

// MARK: - RecommendationsResponse
struct RecommendationsResponse: Codable {
    var tracks: [Track]
    var seeds: [Seed]

    enum CodingKeys: String, CodingKey {
        case tracks = "tracks"
        case seeds = "seeds"
    }
}

// MARK: - Seed
struct Seed: Codable {
    var initialPoolSize: Int?
    var afterFilteringSize: Int?
    var afterRelinkingSize: Int?
    var id: String?
    var type: String?
    var href: String?

    enum CodingKeys: String, CodingKey {
        case initialPoolSize = "initialPoolSize"
        case afterFilteringSize = "afterFilteringSize"
        case afterRelinkingSize = "afterRelinkingSize"
        case id = "id"
        case type = "type"
        case href = "href"
    }
}

// MARK: - UserProfileResponse
struct UserProfileResponse: Codable {
    var country: String?
    var displayName: String?
    var email: String?
    var explicitContent: ExplicitContent?
    var externalUrls: ExternalUrls?
    var followers: Followers?
    var href: String?
    var id: String?
    var images: [Image]?
    var product: String
    var type: String?
    var uri: String?
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case displayName = "display_name"
        case email = "email"
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers = "followers"
        case href = "href"
        case id = "id"
        case images = "images"
        case product = "product"
        case type = "type"
        case uri = "uri"
    }
}

// MARK: - ExplicitContent
struct ExplicitContent: Codable {
    var filterEnabled: Bool?
    var filterLocked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

// MARK: - Followers
struct Followers: Codable {
    var href: JSONNull?
    var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case href = "href"
        case total = "total"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
}

// MARK: - PlayerStateResponse
struct PlayerStateResponse: Codable {
    var device: Device?
    var shuffleState: Bool?
    var repeatState: String?
    var timestamp: Int?
    var context: Context?
    var progressMS: Int
    var item: Item?
    var currentlyPlayingType: String?
    var actions: Actions?
    var isPlaying: Bool?
    
    enum CodingKeys: String, CodingKey {
        case device
        case shuffleState = "shuffle_state"
        case repeatState = "repeat_state"
        case timestamp, context
        case progressMS = "progress_ms"
        case item
        case currentlyPlayingType = "currently_playing_type"
        case actions
        case isPlaying = "is_playing"
    }
}

// MARK: - Device
struct Device: Codable {
    var id: String?
    var isActive, isPrivateSession, isRestricted: Bool?
    var name, type: String?
    var volumePercent: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case isActive = "is_active"
        case isPrivateSession = "is_private_session"
        case isRestricted = "is_restricted"
        case name, type
        case volumePercent = "volume_percent"
    }
}

// MARK: - Item
struct Item: Codable {
    var album: Album?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var discNumber, durationMS: Int?
    var explicit: Bool?
    var externalIDS: ExternalIDS?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var isLocal: Bool?
    var name: String?
    var popularity: Int?
    var previewURL: String?
    var trackNumber: Int?
    var type, uri: String?
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}
