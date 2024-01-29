//
//  SplashFactory.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

enum SplashFactory: SceneFactory {
    static func make() -> SplashViewController {
        let vc = StoryboardBuilder.makeModule(.splash) as! SplashViewController
        let worker = SplashWorker()
        let presenter = SplashPresenter(worker: worker, view: vc)
        vc.presenter = presenter
        
        return vc
    }
}
