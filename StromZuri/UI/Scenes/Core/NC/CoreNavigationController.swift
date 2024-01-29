//
//  CoreNavigationController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit
import Stevia

class CoreNavigationController: UINavigationController {
    private enum Constants {
        enum Colors {
            enum NavigationBar {
                static let backgrondColor: UIColor = .init(hex: 0x0A0F23)
                static let tintColor: UIColor = .label
                static let textColor: UIColor = .label
                
                static let isTranslucent: Bool = false
                static let isOpaque: Bool = true
            }
            
            enum View {
                static let backgroundColor: UIColor = .init(hex: 0x0A0F23)
            }
        }
        
        enum UI {
            enum NavigationBar {
                static let isTranslucent: Bool = false
                static let isOpaque: Bool = true
                static let font: UIFont = InterFontType.medium.fontType(size: 14)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension CoreNavigationController: UIConfigurable {
    
    func setupUI() {
        navigationBar.isTranslucent = Constants.UI.NavigationBar.isTranslucent
        navigationBar.isOpaque = Constants.UI.NavigationBar.isOpaque
        navigationBar.backgroundColor = Constants.Colors.NavigationBar.backgrondColor
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.backgroundColor = Constants.Colors.NavigationBar.backgrondColor
        standardAppearance.titleTextAttributes = [
            .font: Constants.UI.NavigationBar.font,
            .foregroundColor:  Constants.Colors.NavigationBar.textColor
        ]
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.backgroundColor = Constants.Colors.NavigationBar.backgrondColor
        scrollEdgeAppearance.titleTextAttributes = [
            .font: Constants.UI.NavigationBar.font,
            .foregroundColor:  Constants.Colors.NavigationBar.textColor
        ]
        
        navigationBar.standardAppearance = standardAppearance
//        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        navigationBar.tintColor = Constants.Colors.NavigationBar.tintColor
        
        navigationBar.titleTextAttributes = [
            .font: Constants.UI.NavigationBar.font,
            .foregroundColor:  Constants.Colors.NavigationBar.textColor
        ]
        
        view.backgroundColor = Constants.Colors.View.backgroundColor
    }
}

