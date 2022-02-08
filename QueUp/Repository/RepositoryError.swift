//
//  RepositoryError.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/21.
//

import Foundation

enum RepositoryError: Error, LocalizedError {
    case readError(_ error: Error)
    case writeError(_ error: Error)
    case encodingError(_ error: Error)
    case decodingError(_ error: Error)
    case notFound(objectType: FirestoreDocument.Type)
    
    var errorDescription: String? {
        switch self {
        case let .readError(error):
            return error.localizedDescription
        case let .writeError(error):
            return error.localizedDescription
        case let .encodingError(error):
            return error.localizedDescription
        case let .decodingError(error):
            return error.localizedDescription
        case let .notFound(object):
            return "\(object) does not exist"
        }
    }
}
