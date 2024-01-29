//
//  SceneFactory.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit.UIViewController

protocol SceneFactory {
    associatedtype ViewController = UIViewController
    
    static func make() -> ViewController
}
