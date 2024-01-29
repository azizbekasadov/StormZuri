//
//  ListModels.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

enum ListModels {
    enum InitData {
        struct Request {}
        
        struct Response {}
    }
    
    enum FetchData {
        struct Request {}
        
        struct Response {
            let stations: [ListItem]
        }
    }
    
    enum ErrorData {
        struct Request {}
        
        struct Response {
            let error: Error
        }
    }
    
    enum SortData {
        struct Request {}
        
        struct Response {
            let stations: [ListItem]
        }
    }
}
