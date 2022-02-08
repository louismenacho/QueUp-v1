//
//  Member.swift
//  TurnTune
//
//  Created by Louis Menacho on 12/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Member: FirestoreDocument {
    @DocumentID var documentID: String?
    @ServerTimestamp var dateAdded: Timestamp?
    var id: String = ""
    var displayName: String = ""
    var isHost: Bool = false
}

extension Member: Equatable {
    static func ==(lhs: Member, rhs: Member) -> Bool {
        return lhs.id == rhs.id
    }
}
