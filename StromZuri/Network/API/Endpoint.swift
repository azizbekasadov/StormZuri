//
//  Endpoint.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

enum Endpoint: Route {
    case stationsList
    
    var method: HTTPMethod {
        switch self {
        case .stationsList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .stationsList:
            return "ch.bfe.ladestellen-elektromobilitaet/data/ch.bfe.ladestellen-elektromobilitaet.json"
        }
    }
}
