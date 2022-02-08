//
//  AppError.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/6/22.
//

import Foundation

enum AppError: Error, LocalizedError {
    case error(_ message: String)
    case spotifyAppNotFoundError
    case spotifySubscriptionError
    
    var errorDescription: String? {
        switch self {
        case let .error(string):
            return string
        case .spotifyAppNotFoundError:
            return "Spotify app is not installed"
        case .spotifySubscriptionError:
            return "Spotify user must have premium subscription"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .error:
            return nil
        case .spotifyAppNotFoundError:
            return "Go to App store"
        case .spotifySubscriptionError:
            return nil
        }
    }
}
