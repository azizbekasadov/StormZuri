//
//  CoreViewController.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

open class CoreViewController: UIViewController {
    private enum Constants {
        static let bgColor: UIColor = .white
    }
    
    private var toastManager: SZToastManager!
    
    open override func loadView() {
        super.loadView()
        
        toastManager = SZToastManagerImpl(view: self.view)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.bgColor
        overrideUserInterfaceStyle = .light
        
        setupUI()
        setupLayout()
        
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @discardableResult
    public func showError(
        _ message: String,
        completion: ((Bool)->Void)? = nil
    ) -> Self {
        toastManager.showError?(message, completion: completion)
        return self
    }
    
    @discardableResult
    public func showSuccess(
        _ message: String,
        completion: ((Bool)->Void)? = nil
    ) -> Self {
        toastManager.showSuccess?(message, completion: completion)
        return self
    }
    
    @discardableResult
    public func showMessage(
        _ message: String,
        completion: ((Bool)->Void)? = nil
    ) -> Self {
        toastManager.showMessage(message, completion: completion)
        return self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CoreViewController: UIConfigurable {
    public func setupUI() {}
    
    public func setupLayout() {}
}

extension CoreViewController: UILocalizable {
    public func localize() {}
}
