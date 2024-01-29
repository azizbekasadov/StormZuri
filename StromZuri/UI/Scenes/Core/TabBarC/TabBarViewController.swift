//
//  TabBarViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 28/01/24.
//
import UIKit

final class TabBarViewController: UITabBarController {
    private enum Constants {
        static let bgColor = UIColor(hex: 0x1C1D2E)
        static let unselectedTintColor = UIColor.white
        static let selectedTintColor = UIColor.white
        
        enum Images {
            static let _1: UIImage = .init(named: "TabBar/1")!
            static let _2: UIImage = .init(named: "TabBar/2")!
        }
    }
    
    private lazy var mapViewController: UIViewController = {
        let viewController = MainFactory.make()
        viewController.tabBarItem = .init(
            title: "Map",
            image: Constants.Images._1.withRenderingMode(.alwaysTemplate),
            selectedImage: Constants.Images._1.withRenderingMode(.alwaysTemplate)
        )
        return viewController
    }()
    
    private lazy var listValuesController: UIViewController = {
        let viewController = ListFactory.make()
        viewController.tabBarItem = .init(
            title: "List",
            image: Constants.Images._2.withRenderingMode(.alwaysTemplate),
            selectedImage: Constants.Images._2.withRenderingMode(.alwaysTemplate)
        )
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildren()
        configureViews()
    }
    
    private func setupChildren() {
        let vcs = [
            mapViewController.withNavigation(isTransparent: true),
            listValuesController.withNavigation(isTransparent: false),
        ]
        
        self.viewControllers = vcs
    }
    
    private func configureViews() {
        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = Constants.bgColor
        standardAppearance.configureWithTransparentBackground()
        
        let scrollEdgeAppearance = UITabBarAppearance()
        scrollEdgeAppearance.backgroundColor = Constants.bgColor
        scrollEdgeAppearance.configureWithTransparentBackground()
        scrollEdgeAppearance.backgroundImage = .init(named: "TabBar/bg")
        
        tabBar.standardAppearance = standardAppearance
        tabBar.scrollEdgeAppearance = scrollEdgeAppearance
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = Constants.bgColor
        tabBar.isOpaque = true
        tabBar.unselectedItemTintColor = Constants.unselectedTintColor
        tabBar.tintColor = Constants.selectedTintColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

