//
//  MainViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

import UIKit
import Stevia
import MapKit

protocol MainViewDisplayLogic: AnyObject {
    func initViews(_ response: Any)
    func fetchStations(_ response: Any)
}

final class MainViewController: CoreViewController {
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        return mapView
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(named: "Home/settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.tintColor = .init(hex: 0x6C6C6C)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(named: "Home/compass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.backgroundColor = UIColor.systemBackground
        button.tintColor = .init(hex: 0x6C6C6C)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()
    
    private let sideView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.systemBackground
        return view
    }()
    
    private let sideDelimiterView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x6C6C6C)
        return view
    }()
    
    private lazy var sideStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [
                settingsButton, sideDelimiterView, currentLocationButton
            ]
        )
        stack.spacing = 4
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    private let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .vertical)
        label.font = InterFontType.medium.fontType(size: 14.0)
        label.textColor = UIColor(hex: 0x1C1D2E)
        return label
    }()
    
    private let lastUpdateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    private var locationManager: LocationManager = .shared
    private let store = StationsStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        store.delegate = self
        
        currentLocationButton.addTapGesture {
            self.locationManager.startUpdatingLocation()
        }
        
        lastUpdateLabel.text = "Last update - \(AppStorage.lastUpdate.formatDateToString())"
        
        store.startUpdating()
    }
    
    override func setupUI() {
        view.subviews(mapView, sideView, lastUpdateView)
        
        lastUpdateView.subviews(lastUpdateLabel)
        sideView.subviews(sideStackView)
    }
    
    override func setupLayout() {
        mapView.Top == view.Top
        mapView.Bottom == view.Bottom
        mapView.fillHorizontally()
        
        [settingsButton, currentLocationButton].forEach { $0.size(44) }
        sideDelimiterView.height(0.25)
        lastUpdateLabel.fillVertically(padding: 10.0).fillHorizontally(padding: 20.0)
        sideStackView.fillContainer()
        sideView.Top == view.safeAreaLayoutGuide.Top + 10
        sideView.Trailing == view.safeAreaLayoutGuide.Trailing - 10
        
        lastUpdateView.Bottom == view.safeAreaLayoutGuide.Bottom - 20
        lastUpdateView.centerHorizontally()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sideView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension MainViewController: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: Location) {
        setupCurrentRegionView(location: location)
        layoutAnnotations()
    }
    
    func locationManager(_ manager: LocationManager, didFailWithError error: Error) {
        showError(error.localizedDescription)
    }
    
    private func layoutAnnotations() {
        DispatchQueue(
            label: GlobalConstants.bundleID + ".fetch.annotations",
            qos: .userInitiated
        ).async {
            let entites = self.store.fetchByLocation()
            let annotations = entites.compactMap {
                StationAnnotation(item: $0)
            }
            
            DispatchQueue.main.async {
                annotations.forEach {
                    self.mapView.addAnnotation($0)
                }
            }
        }
    }
    
    private func setupCurrentRegionView(location: Location) {
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    private func fetchPeriodicValues() {
    }
}

extension MainViewController: StationsStoreDelegate {
    func fetchRecords(_ stations: [StationDTO]) {
        mapView.removeAnnotations(mapView.annotations)
        lastUpdateLabel.text = "Last update - \(AppStorage.lastUpdate.formatDateToString())"
        
        layoutAnnotations()
    }
}
