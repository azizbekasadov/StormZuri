//
//  UserDefault.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

// Wrappers

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let name: String
    public var defaultValue: Value
    
    public var container: UserDefaults = .standard
    
    public var wrappedValue: Value {
        get {
            get(key: key) ?? defaultValue
        } set {
            save(value: newValue, name: name, key: key)
        }
    }
}

private extension UserDefault {
    func get(key: String) -> Value? {
        container.object(forKey: key) as? Value ?? defaultValue
    }
    
    func save(value: Value?, name: String, key: String) {
        if let new = value {
            print(">>> StromZuri -> \(name) \(String(describing: new)) stored.")
            container.set(new, forKey: key)
        } else {
            print(">>> StromZuri -> \(name) removed.")
            container.removeObject(forKey: key)
        }
    }
}
