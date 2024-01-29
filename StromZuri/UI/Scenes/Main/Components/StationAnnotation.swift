//
//  StationAnnotation.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 29/01/24.
//

import MapKit

final class StationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(
        coordinate: CLLocationCoordinate2D, 
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
    
    init(item: StationDTO) {
        self.coordinate = item.coordinates ?? .init(latitude: .zero, longitude: .zero)
        self.title = item.stationName
        self.subtitle = item.chargingPower?.description
    }
}
