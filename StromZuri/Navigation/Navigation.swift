//
//  Navigation.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit
import SafariServices

public struct Navigation {
    public typealias Identifier = Int
    
    public static var keyWindow: UIWindow?
    
    @discardableResult
    public init(keyWindow: UIWindow?) {
        keyWindow?.overrideUserInterfaceStyle = .light
        
        Navigation.keyWindow = keyWindow
        configureViews()
    }
    
    private func configureViews() {
        let offset = UIOffset(horizontal: -1000, vertical: 0)
        
        UIBarButtonItem.appearance()
            .setBackButtonTitlePositionAdjustment(offset, for: UIBarMetrics.default)
    }
    
    public static var visibleViewController: UIViewController? {
        if let visibleVC = Navigation.keyWindow?.visibleViewController {
            return visibleVC
        }
        return nil
    }

    public static var visibleViewControllerIgnoringBottomTabBar: UIViewController? {
        guard let visibleVC = Navigation.keyWindow?.visibleViewControllerIgnoringBottomTabBar else {
            return nil
        }
        
        return visibleVC
    }

    fileprivate static var rootNavigationController: UINavigationController? {
        return Navigation.keyWindow?.rootViewController as? UINavigationController
    }
}

// MARK: - Navigation Configuration

extension Navigation {
    enum TransitionType {
        struct PresentTransitionConfig {
            let modalPresentationStyle: UIModalPresentationStyle?
            let modalTransitionStyle: UIModalTransitionStyle?
            
            static let `default`: PresentTransitionConfig = {
                PresentTransitionConfig(
                    modalPresentationStyle: .fullScreen,
                    modalTransitionStyle: .crossDissolve
                )
            }()
            
            static let overFullScreen: PresentTransitionConfig = {
                PresentTransitionConfig(
                    modalPresentationStyle: .overFullScreen,
                    modalTransitionStyle: .crossDissolve
                )
            }()
        }

        case push
        case present(config: PresentTransitionConfig?)
    }
    
    static func instantiateViewController(_ controllerID: NavigationIdentifier) -> UIViewController? {
        guard let vc = configure(controllerFor: controllerID) else {
            debugPrint("Can't instantiate controller \(controllerID)!")
            return nil
        }
            
        return vc
    }
    
    
    fileprivate static func configure(controllerFor identifier: NavigationIdentifier) -> UIViewController? {
        switch identifier {
        case .userLocation:
            return UserLocationFactory.make()
        case .home:
            return MainFactory.make().withNavigation(isTransparent: true)
        case .onboarding:
            return OnboardingFactory.make()
        case .splash:
            return SplashFactory.make()
        default:
            return CoreViewController()
        }
    }
    
    static func navigate(to controllerID: NavigationIdentifier,
                         type: TransitionType = .push,
                         embeddedInNavigationController: Bool = false,
                         tryPresentIfPushingFails: Bool = true,
                         animated: Bool = true,
                         on sourceVC: UIViewController? = nil,
                         shouldHideBottomBar: Bool = false) {
        guard let vc = instantiateViewController(controllerID) else {
            return
        }

        var resultViewController: UIViewController
        resultViewController = embeddedInNavigationController ? vc.withNavigation() : vc
        
        resultViewController.hidesBottomBarWhenPushed = shouldHideBottomBar
        
        DispatchQueue.main.async {
            switch type {
            case .push:
                if let navigationC = sourceVC?.navigationController ?? rootNavigationController {
                    navigationC.hidesBottomBarWhenPushed = true
                    navigationC.pushViewController(resultViewController, animated: animated)
                } else if tryPresentIfPushingFails {
                    debugPrint("Can't push \(controllerID), trying to present")
                    
                    navigate(to: controllerID,
                             type: .present(config: nil),
                             tryPresentIfPushingFails: false,
                             on: sourceVC)
                } else {
                    debugPrint("Failed to push \(controllerID)")
                }
            case .present(let config):
                if let sourceVC = sourceVC ?? visibleViewController {
                    if config == nil {
                        resultViewController = resultViewController.withNavigation()
                    }
                    
                    if let presentationStyle = config?.modalPresentationStyle {
                        resultViewController.modalPresentationStyle = presentationStyle
                    }
                    if let transitionStyle = config?.modalTransitionStyle {
                        resultViewController.modalTransitionStyle = transitionStyle
                    }

                    if let presentationDelegate = visibleViewControllerIgnoringBottomTabBar
                        as? UIAdaptivePresentationControllerDelegate {
                        resultViewController.presentationController?.delegate = presentationDelegate
                    }

                    sourceVC.present(resultViewController, animated: animated, completion: nil)
                } else {
                    debugPrint("Failed to present \(controllerID)")
                }
            }
        }
    }

    public static func close(_ wrappedController: UIViewController?) {
        guard let controller = wrappedController else { return }

        if let navVC = controller.navigationController, navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: true)
        } else {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension Navigation {
    static func makeMainAsRoot() {
        make(asRoot: .main)
    }

    static func make(asRoot: RootableNavigationIdentifier, embedInNavigation: Bool = false) {
        var viewController: UIViewController = CoreViewController()

        switch asRoot {
        case .splash:
            viewController = SplashFactory.make()
        case .onboarding:
            viewController = OnboardingFactory.make()
        case .main:
            viewController = TabBarViewController()
        default:
            viewController = UIViewController()
        }

        if embedInNavigation {
            let nav = viewController.withNavigation()
            Navigation.makeAsRoot(viewController: nav)
        } else {
            Navigation.makeAsRoot(viewController: viewController)
        }
    }

    fileprivate static func makeAsRoot(viewController: UIViewController) {
        debugPrint("Making root \(viewController)")
        
        if let window = Navigation.keyWindow {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        } else {
            print("StormZuri error: <Navigation> -> The window doesn't exist.")
        }
    }
}

// MARK: - Safari

extension Navigation {
    static func openURL(path: String?, delegate: SFSafariViewControllerDelegate? = nil) {
        guard let url = URL(string: path ?? "") else {
            debugPrint("String is not a URL.")
            return
        }

        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            DispatchQueue.main.async { [weak visibleViewController] in
                let sVC = SFSafariViewController(url: url)
                sVC.dismissButtonStyle = .close
                sVC.preferredBarTintColor = UIColor.systemBackground
                sVC.preferredControlTintColor = UIColor.systemBlue
                sVC.delegate = delegate
                visibleViewController?.present(sVC, animated: true, completion: nil)
            }
        } else {
            openURLInApp(path: path)
        }
    }

    static func openURLInApp(path: String?) {
        guard let url = URL(string: path ?? "") else {
            debugPrint("String is not a URL.")
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            debugPrint("Can't open URL")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

