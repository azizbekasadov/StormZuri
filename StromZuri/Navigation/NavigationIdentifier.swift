//
//  NavigationIdentifier.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

enum NavigationIdentifier {
    case onboarding
    case splash
    case home
    case settings
    case list
    case paywall
    case userLocation
}

// MARK: - Equatable

extension NavigationIdentifier: Equatable {
    public static func == (lhs: NavigationIdentifier, rhs: NavigationIdentifier) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}
