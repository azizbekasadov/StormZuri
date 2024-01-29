//
//  UIViewController+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

extension UIViewController {
    @objc
    func popCurrentViewController() {
        Navigation.close(self)
    }
    
    func withNavigation(isTransparent: Bool = false) -> UINavigationController {
        let nav = isTransparent ? TranslucentNavigationController(rootViewController: self) : CoreNavigationController(rootViewController: self)
        nav.overrideUserInterfaceStyle = .dark
        return nav
    }
}
