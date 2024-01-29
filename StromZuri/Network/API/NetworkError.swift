//
//  NetworkErrorNetworkError.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

public enum NetworkError: Error {
    case noInternetConnection
    case unableToGetStatusCode
    case couldNotDecodeResponseData(description: String)
    case clientError
    case timeout
    case dataIsNil
    
    var localizedDescription: String {
        switch self {
        case .dataIsNil:
            return "Response data is nil"
            
        default:
            return ""
        }
    }
}
