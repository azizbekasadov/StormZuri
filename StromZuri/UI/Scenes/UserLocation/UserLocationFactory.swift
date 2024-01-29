//
//  UserLocation.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//

import Foundation

enum UserLocationFactory: SceneFactory {
    static func make() -> UserLocationViewController {
        let presenter = UserLocationPresenter()
        let vc = UserLocationViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
