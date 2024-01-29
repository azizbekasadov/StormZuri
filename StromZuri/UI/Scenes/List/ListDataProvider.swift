//
//  ListDataProvider.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import Foundation

protocol ListDataProvider {
    func fetchData(completion: @escaping (Result<[StationDTO], Error>) -> Void)
}

final class ListDataProviderImpl: ListDataProvider {
    enum ListDataProviderError: Error {
        case emptyList
    }
    
    private let store = StationsStore.shared
    
    func fetchData(completion: @escaping (Result<[StationDTO], Error>) -> Void) {
        DispatchQueue(label: GlobalConstants.bundleID + ".fetch.listData", qos: .background).async {
            let res = self.store.stations.isEmpty ? self.store.fetchByLocation() : self.store.stations
            if res.isEmpty {
                completion(.failure(ListDataProviderError.emptyList))
            } else {
                completion(.success(res.sorted(by: .dsc)))
            }
        }
    }
}

