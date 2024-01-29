//
//  AppStorage.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

final class AppStorage {
    @UserDefault(key: Constants.Keys.didFinishOnboarding,
                 name: "DidFinishOnboarding",
                 defaultValue: false)
    static var didFinishOnboarding: Bool
    
    @UserDefault(key: Constants.Keys.didFinishOnboarding,
                 name: "LastUpdate",
                 defaultValue: Date())
    static var lastUpdate: Date
}

extension AppStorage {
    struct Constants {
        struct Keys {
            static let didFinishOnboarding = "12e121dasdwdsv"
            static let lastUpdate = "2edqwefrgethrgefwwd"
        }
    }
}
