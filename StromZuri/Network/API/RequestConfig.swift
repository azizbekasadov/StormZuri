//
//  RequestConfig.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

struct RequestConfig {
    var method: HTTPMethod
    var headers: [String: String]?
    var queryParameters: [String: String]?
    var requestData: Data?
}
