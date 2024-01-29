//
//  StationsAPI.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Combine

protocol StationsAPIService {
    func fetchStations(completion: @escaping (Result<EVSEResponse, Error>) -> Void)
}

final class StationsAPI:StationsAPIService {
    private let apiService: APIServiceProtocol = APIService(baseURL: "https://data.geo.admin.ch/")

    private var timer: Timer?

    func fetchStations(completion: @escaping (Result<EVSEResponse, Error>) -> Void) {
        self.apiService.performRequest(
            endpoint: .stationsList,
            config: .init(method: .get),
            completion: completion
        )
    }
}
