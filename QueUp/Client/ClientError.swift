//
//  ClientError.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/18/21.
//

import Foundation

enum ClientError: Error, LocalizedError {
    case requestFailed(_ error: Error)
    case decodingError(_ error: Error)
    case badResponse(code: Int, description: String, json: AnyObject)
    case noResponse
    
    var errorDescription: String? {
        switch self {
        case let .requestFailed(error):
            return error.localizedDescription
        case let .decodingError(error):
            return error.localizedDescription
        case let .badResponse(_, description, _):
            return description
        case .noResponse:
            return "No response"
        }
    }
}
