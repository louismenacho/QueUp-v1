//
//  PlaylistItem.swift
//  TurnTune
//
//  Created by Louis Menacho on 1/4/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PlaylistItem: FirestoreDocument {
    @DocumentID var documentID: String?
    @ServerTimestamp var dateAdded: Timestamp?
    
    var song: Song
    var addedBy: Member
    
    init() {
        song = Song()
        addedBy = Member()
    }
    
    init(song: Song, addedBy: Member) {
        self.song = song
        self.addedBy = addedBy
    }
}
