//
//  StationsStore.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 29/01/24.
//

import UIKit.UIImage

enum SortingType {
    case asc
    case dsc
    
    var image: UIImage? {
        switch self {
        case .asc:
            return "List/asc".image
        case .dsc:
            return "List/dsc".image
        }
    }
    
    mutating func toggle() -> SortingType {
        self == .asc ? .dsc : .asc
    }
}

protocol StationsStoreDelegate: AnyObject {
    func fetchRecords(_ stations: [StationDTO])
}

final class StationsStore {
    private(set) var stations: [StationDTO] = []
    private var timer: Timer?
    
    private var apiService: StationsAPIService = StationsAPI()
    
    private init() {}
    
    weak var delegate: StationsStoreDelegate?
    
    static let shared: StationsStore = .init()
    
    func sort(by type: SortingType) -> [StationDTO] {
        stations.sorted {
            switch type {
            case .asc:
                return $0.chargingPower?.input ?? 0 < $1.chargingPower?.input ?? 0
            case .dsc:
                return $0.chargingPower?.input ?? 0 > $1.chargingPower?.input ?? 0
            }
        }
    }
    
    func startUpdating() {
        timer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func updateRecordsWithTimer() {
        let records = self.fetchStations()
        
        if records.isEmpty {
            apiService.fetchStations { [weak self] result in
                AppStorage.lastUpdate = Date()
                
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    let records = Array(success.evseData.compactMap { $0.evseDataRecord }.joined())
                    self.stations = records.compactMap { $0.convert() }
                    self.updateRecords(records)
                    self.delegate?.fetchRecords(self.fetchByLocation())
                case .failure(let failure):
                    (Navigation.keyWindow?.rootViewController as? CoreViewController)?.showError(failure.localizedDescription)
                }
            }
        } else {
            self.delegate?.fetchRecords(self.stations)
        }
    }
    
    @objc
    private func timerFired() {
        updateRecordsWithTimer()
    }
    
    @discardableResult
    func updateRecords(_ items: [EVSEDataRecord]) -> [StationDTO] {
        self.stations = self.fetchStations()

        var updatedItems: [StationDTO] = []
        let items = items.compactMap{
            $0.convert()
        }
        
        var processedLastUpdateSet: Set<String> = []

        for newItem in items {
            if !processedLastUpdateSet.contains(newItem.lastUpdate) {
                if let existingIndex = stations.firstIndex(where: { $0.lastUpdate == newItem.lastUpdate }) {
                    stations[existingIndex] = newItem
                } else {
                    stations.append(newItem)
                }
                updatedItems.append(newItem)
                processedLastUpdateSet.insert(newItem.lastUpdate)
            }
        }
        
        let storage = AppPreferences.shared.storage
        storage.removeAll(
            type: StationEntity.self,
            predicate: NSPredicate(format: "id IN %@", self.stations.compactMap { $0.id })
        )
        
        updatedItems.forEach {
            _ = StationEntity(item: $0)
        }
        
        storage.write()
        return self.stations
    }
    
    @discardableResult
    func fetchStations() -> [StationDTO] {
        let storage = AppPreferences.shared.storage
        let entities = storage.fetch(type: StationEntity.self)
        
        self.stations = entities?.compactMap { item in
            StationDTO(
                id: item.id,
                openingHours: item.openingTimes,
                lastUpdate: item.lastUpdate,
                address: item.address,
                coordinates: .init(
                    latitude: LocationDegrees(item.coordinatesLat?.doubleValue ?? 0.0),
                    longitude: LocationDegrees(item.coordinatesLon?.doubleValue ?? 0.0)
                ),
                hotlinPhoneNumber: item.hotlinePhoneNumber,
                image: item.image,
                stationName: item.stationName,
                chargingPower: {
                    if let chargingPower = item.chargingPower, let chargingPowerDesc = item.chargingPowerDesc {
                        return .init(input: chargingPower.doubleValue, description: chargingPowerDesc)
                    }
                    return nil
                }()
            )
        } ?? []
        return self.stations
    }
    
    @discardableResult
    func fetchByLocation() -> [StationDTO] {
        let res = self.stations.isEmpty ? self.fetchStations() : self.stations
        return res.filter {
            if let coors = $0.coordinates, let userCoors = LocationManager.shared.location {
                return LocationCoordinatesAdapter.calculateDistance(from: coors, to: userCoors.coordinate) <= 1000
            }
            return false
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
