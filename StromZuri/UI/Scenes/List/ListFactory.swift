//
//  ListFactory.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 27/01/24.
//

import UIKit.UIViewController

final class ListFactory: SceneFactory {
    static func make() -> ListViewController {
        let dataProvider = ListDataProviderImpl()
        let listAdapter = ListItemAdapterImpl()
        let vc = ListViewController()
        let presenter = ListPresenter(
            dataProvider: dataProvider,
            listAdapter: listAdapter,
            view: vc
        )
        vc.presenter = presenter
        
        return vc
    }
}
