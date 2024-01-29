//
//  TranslucentNavigationController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

final class TranslucentNavigationController: CoreNavigationController {
    
    override func setupUI() {
        super.setupUI()
        
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        view.backgroundColor = .clear
    }
}

