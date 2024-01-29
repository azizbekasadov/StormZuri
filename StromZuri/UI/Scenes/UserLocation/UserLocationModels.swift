//
//  UserLocationModels.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Foundation

enum UserLocationModels {
    enum InitData {
        struct Request {}
        
        struct Response {}
    }
    
    enum ErrorData {
        struct Request {}
        
        struct Response {
            let error: Error
        }
    }
    
    enum ContinueButton {
        struct Request {}
        
        struct Response {}
    }
    
    enum UserLocation {
        struct Request {}
        
        struct Response {
            let isAllowedTracking: Bool
        }
    }
}
