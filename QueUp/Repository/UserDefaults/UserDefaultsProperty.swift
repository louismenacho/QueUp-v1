//
//  UserDefaultsProperty.swift
//  TurnTune
//
//  Created by Louis Menacho on 5/14/21.
//

import Foundation

@propertyWrapper
struct UserDefaultsProperty<Value> {
    
    private let key: String
    private let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            let value = UserDefaults.standard.object(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
    
    init(wrappedValue: Value, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
    }
}
