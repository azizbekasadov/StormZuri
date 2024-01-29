//
//  APIRoute.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import Foundation

protocol Route {
    var path: String { get }
    var method: HTTPMethod { get }
}
