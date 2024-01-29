//
//  UserLocationPresenter.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Foundation

protocol UserLocationPresentationLogic: AnyObject {
    func initViews(_ request: UserLocationModels.InitData.Request)
    func requestUserLocation(_ request: UserLocationModels.UserLocation.Request)
}

final class UserLocationPresenter {
    
    private let locationManager: LocationManager = .shared
    
    weak var view: UserLocationDisplayLogic?
    
    init() {
        locationManager.delegate = self
    }
}

extension UserLocationPresenter: UserLocationPresentationLogic {
    func initViews(_ request: UserLocationModels.InitData.Request) {
        view?.initViews(.init())
    }
    
    func requestUserLocation(_ request: UserLocationModels.UserLocation.Request) {
        locationManager.requestLocationAuthorization()
    }
}

extension UserLocationPresenter: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: Location) {
        view?.receivedUserLocation(.init(isAllowedTracking: manager.isAllowedToTrackLocation))
    }
    
    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {
        view?.receivedError(.init(error: error))
    }
}
