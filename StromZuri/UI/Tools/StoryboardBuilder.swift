//
//  StoryboardBuilder.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

enum StoryboardBuilder {
    static func makeModule(_ storyboardName: Storyboard) -> UIViewController {
        guard let vc = UIStoryboard(
            name: storyboardName.boardName,
            bundle: nil)
        .instantiateInitialViewController()
        else {
            fatalError("Unable to instantiate Storyboard")
        }
        
        return vc
    }
}
