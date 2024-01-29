//
//  Storyboard.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

enum Storyboard: String, CaseIterable {
    case splash = "Splash"
    case onboarding = "Onboarding"
    
    var boardName: String {
        var _boardName: String = self.rawValue
        _boardName = _boardName.replacingOccurrences(of: " ", with: "")
        return _boardName
    }
}

// MARK: - Custom Description for better screen instatiation
extension Storyboard: CustomStringConvertible {
    var description: String {
        var boardName: String = self.rawValue.capitalized
        boardName = boardName.replacingOccurrences(of: " ", with: "")
        return "\(boardName) is instatiated from Storyboard"
    }
}
