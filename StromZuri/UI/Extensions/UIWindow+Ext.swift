//
//  UIWindow+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

public extension UIWindow {
    var visibleViewController: UIViewController? {
        UIWindow.visibleViewController(from: rootViewController)
    }
    
    var visibleViewControllerIgnoringBottomTabBar: UIViewController? {
        UIWindow.visibleViewController(from: rootViewController,
                                              shouldIgnoreBottomTabBar: true)
    }
    
    static func visibleViewController(
        from viewController: UIViewController?,
        shouldIgnoreBottomTabBar: Bool = false
    ) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(
                from: navigationController.visibleViewController,
                shouldIgnoreBottomTabBar: shouldIgnoreBottomTabBar
            )
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(
                from: tabBarController.selectedViewController,
                shouldIgnoreBottomTabBar: shouldIgnoreBottomTabBar
            )
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(
                from: presentingViewController?.presentedViewController,
                shouldIgnoreBottomTabBar: shouldIgnoreBottomTabBar
            )
        default:
            return viewController
        }
    }
    
    func closeAllModalControllers(completion: (()->Void)? = nil) {
        rootViewController?.dismiss(animated: true) {
            completion?()
        }
    }
    
    private func dismissModalNavigationControllerRecursively() {
        // Yes, this looks weird
        guard let navigationController = rootViewController?
            .presentedViewController as? UINavigationController 
        else { return }

        
        navigationController.dismiss(animated: true) { [weak self] in
            self?.dismissModalNavigationControllerRecursively()
        }
    }
}
