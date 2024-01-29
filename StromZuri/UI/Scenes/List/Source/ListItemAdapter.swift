//
//  ListItemAdapter.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Foundation

protocol ListItemAdapter {
    func convert(_ items: [StationDTO]) -> [ListItem]
}

final class ListItemAdapterImpl: ListItemAdapter {
    private var locationManager: LocationManager = .shared
    
    func convert(_ items: [StationDTO]) -> [ListItem] {
        guard let currentLocation = locationManager.location else {
            return []
        }
        
        return items.compactMap { item in
                .init(
                    id: item.id,
                    icon: "Station/icon",
                    stationName: item.stationName,
                    distance: String(format: "%.0f", LocationCoordinatesAdapter.calculateDistance(from: currentLocation.coordinate, to: item.coordinates!)) + " m",
                    chargingPower: {
                        if let input = item.chargingPower?.input {
                            return "\(Int(input)) W"
                        } else {
                            return "-- W"
                        }
                    }(),
                    available: item.openingHours ?? ""
                )
        }
    }
}
