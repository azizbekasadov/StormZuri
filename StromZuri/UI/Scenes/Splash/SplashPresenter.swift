//
//  SplashPresenter.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

protocol SplashPresentationLogic: AnyObject {
    func initViews(_ request: SplashModels.InitData.Request)
    func fetchStations(_ request: SplashModels.StationsData.Request)
}

final class SplashPresenter {
    private let worker: SplashWorkerLogic
    private weak var view: SplashDisplayLogic?
    private let store = StationsStore.shared
    
    init(worker: SplashWorkerLogic, view: SplashDisplayLogic?) {
        self.worker = worker
        self.view = view
    }
}

extension SplashPresenter: SplashPresentationLogic {
    func initViews(_ request: SplashModels.InitData.Request) {
        view?.initViews(.init())
    }
    
    func fetchStations(_ request: SplashModels.StationsData.Request) {
        let stations = store.fetchStations()
        if stations.isEmpty {
            fetchStationsRemote()
        } else {
            view?.didFetchStations(.init(stations: stations))
        }
    }
    
    private func fetchStationsRemote() {
        worker.fetchStations { [weak self] result in
            AppStorage.lastUpdate = Date()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                let records = self.store.updateRecords(success)
                self.view?.didFetchStations(.init(stations: records))
            case .failure(let failure):
                self.view?.receivedError(.init(error: failure))
            }
        }
    }
}
