//
//  SceneDelegate.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        let window = UIWindow(windowScene: windowScene)
        
        Navigation(keyWindow: window)
        Navigation.make(asRoot: .splash)
    }
}

