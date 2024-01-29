//
//  OnboardingFactory.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

final class OnboardingFactory: SceneFactory {
    static func make() -> OnboardingViewController {
        let dataProvider = OnboardingDataProviderImp()
        let presenter = OnboardingPresenter(dataProvider: dataProvider)
        let viewController = OnboardingViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
