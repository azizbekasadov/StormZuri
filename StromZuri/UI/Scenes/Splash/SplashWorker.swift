//
//  SplashWorker.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

protocol SplashWorkerLogic {
    func fetchStations(completion: @escaping (Result<[EVSEDataRecord], Error>) -> Void)
}

struct SplashWorker: SplashWorkerLogic {
    private let apiService: StationsAPIService = StationsAPI()
    
    func fetchStations(completion: @escaping (Result<[EVSEDataRecord], Error>) -> Void) {
        apiService.fetchStations { result in
            switch result {
            case .success(let data):
                let receivedData = Array(data.evseData.map { $0.evseDataRecord }.joined())
                print(receivedData[0])
                completion(.success(receivedData))
                return
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
