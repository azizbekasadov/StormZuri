//
//  CoreDataError.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

// MARK: - Private methods

enum CoreDataError: Error, LocalizedError {
    case requestCreationFail
    
    var errorDescription: String? {
        switch self {
        case .requestCreationFail:
            return "Request creation failed."
        }
    }
}
