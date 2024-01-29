//
//  SplashViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

protocol SplashDisplayLogic: AnyObject {
    func initViews(_ response: SplashModels.InitData.Response)
    func didFetchStations(_ response: SplashModels.StationsData.Response)
    func receivedError(_ response: SplashModels.ErrorData.Response)
}

final class SplashViewController: CoreViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: SplashPresentationLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        
        presenter?.initViews(.init())
    }
    
    override func setupUI() {
        view.backgroundColor = .init(hex: 0x1C1D2E)
    }
}

extension SplashViewController: SplashDisplayLogic {
    func initViews(_ response: SplashModels.InitData.Response) {
        presenter?.fetchStations(.init())
    }
    
    func didFetchStations(_ response: SplashModels.StationsData.Response) {
        print(response.stations)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            if AppStorage.didFinishOnboarding {
                Navigation.makeMainAsRoot()
            } else {
                Navigation.navigate(to: .onboarding, type: .present(config: .overFullScreen))
            }
        }
    }
    
    func receivedError(_ response: SplashModels.ErrorData.Response) {
        showError(response.error.localizedDescription) { _ in
            // do something
        }
    }
}
