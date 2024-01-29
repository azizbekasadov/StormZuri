//
//  ListItem.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

// Cell
// icon
// station name
// distance km
// id
// charging power
// available

struct ListItem: BuildingBlock {
    let id: String
    let icon: String
    let stationName: String
    let distance: String?
    let chargingPower: String?
    let available: String
}
