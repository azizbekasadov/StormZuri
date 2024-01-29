//
//  StationDTO.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 29/01/24.
//

import Foundation

struct StationDTO: Identifiable {
    let id: String
    let openingHours: String?
    let lastUpdate: String
    let address: String
    let coordinates: Coordinates2D?
    let hotlinPhoneNumber: String?
    let image: String?
    let stationName: String
    let chargingPower: PowerValue?
}

struct PowerValue {
    let input: Double
    let description: String
    
    init(input: Double, description: String) {
        self.input = input
        self.description = description
    }
    
    init(power: Power) {
        self.init(input: power.value, description: power.description + " W")
    }
}

extension Array where Element == StationDTO {
    func sorted(by sortingType: SortingType) -> [StationDTO] {
        switch sortingType {
        case .asc:
            return self.sorted { $0.chargingPower?.input ?? 0 < $1.chargingPower?.input ?? 0 }
        case .dsc:
            return self.sorted { $0.chargingPower?.input ?? 0 > $1.chargingPower?.input ?? 0 }
        }
    }
}
