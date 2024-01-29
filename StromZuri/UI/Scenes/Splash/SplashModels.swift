//
//  SplashModels.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

enum SplashModels {
    enum InitData {
        struct Request {}
        
        struct Response {}
    }
    
    enum StationsData {
        struct Request {}
        
        struct Response {
            let stations: [StationDTO]
        }
    }
    
    enum ErrorData {
        struct Request {}
        
        struct Response {
            let error: Error
        }
    }
}
