//
//  FirestoreDocument.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/31/21.
//

import Foundation
import FirebaseFirestore

protocol FirestoreDocument: Codable {
    var documentID: String? { get set }
    var dateAdded: Timestamp? { get set }
}
