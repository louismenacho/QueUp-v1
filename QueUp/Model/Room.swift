//
//  Room.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/27/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Room: FirestoreDocument {
    @DocumentID var documentID: String?
    @ServerTimestamp var dateAdded: Timestamp?
    var id: String = ""
    var host = Member()
    var memberCount: Int = 0
    var spotifyToken: String = ""
    var spotifyTokenExpirationDate = Date()
}
