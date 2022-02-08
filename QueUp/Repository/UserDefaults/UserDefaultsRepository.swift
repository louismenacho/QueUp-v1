//
//  UserDefaultsRepository.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/14/21.
//

import Foundation

class UserDefaultsRepository {
    
    @UserDefaultsProperty(key: "Display Name")
    var displayName = ""
    
    @UserDefaultsProperty(key: "Room ID")
    var roomID = ""
}
