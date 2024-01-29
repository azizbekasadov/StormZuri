//
//  LocationManager.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import CoreLocation

typealias Location = CLLocation
typealias Coordinates2D = CLLocationCoordinate2D
typealias LocationDegrees = CLLocationDegrees

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: Location)
    func locationManager(_ manager: LocationManager, didFailWithError error: Error)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()

    var isAllowedToTrackLocation: Bool {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways, .authorized:
            return true
        default:
            return false
        }
    }
    
    var location: Location? {
        locationManager.location
    }
    
    weak var delegate: LocationManagerDelegate?

    static let shared: LocationManager = .init()
    
    override init() {
        super.init()
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.locationManager(self, didUpdateLocation: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManager(self, didFailWithError: error)
    }
}

enum LocationCoordinatesAdapter {
    static func convert(_ geoCoordinatesString: String) -> CLLocationCoordinate2D? {
        let components = geoCoordinatesString.components(separatedBy: " ")

        guard components.count == 2, let latitude = Double(components[0]), let longitude = Double(components[1]) else {
            print("Invalid GeoCoordinates format")
            return nil
        }

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func calculateDistance(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> CLLocationDistance {
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationCLLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)

        return userCLLocation.distance(from: destinationCLLocation)
    }
}
