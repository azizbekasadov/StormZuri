//
//  MainFactory.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 26/01/24.
//

final class MainFactory: SceneFactory {
    static func make() -> MainViewController {
        let vc = MainViewController()
        return vc
    }
}
