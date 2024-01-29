//
//  SZToastManager.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit
import Toast

@objc
protocol SZToastManager: AnyObject {
    func showMessage(_ message: String, completion: ((Bool)->Void)?)
    
    @objc
    optional func showError(_ message: String, completion: ((Bool)->Void)?)
    
    @objc
    optional func showSuccess(_ message: String, completion: ((Bool)->Void)?)
    
    init(view: UIView)
}


final class SZToastManagerImpl: SZToastManager {
    private enum SZToastType {
        case error
        case success
        case `default`
        
        var backgroundColor: UIColor {
            switch self {
            case .error:
                return .red.withAlphaComponent(0.85)
            case .success:
                return .green.withAlphaComponent(0.85)
            case .default:
                return .black.withAlphaComponent(0.85)
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .error:
                return .white
            case .success:
                return .white
            case .default:
                return .white
            }
        }
    }
    
    unowned var view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    private func _showMessage(
        _ message: String,
        type: SZToastType = .default,
        completion: ((Bool) -> Void)? = nil
    ) {
        var style = ToastStyle()
        style.backgroundColor = type.backgroundColor
        style.cornerRadius = 12
        style.messageFont = InterFontType.regular.fontType(size: 14)
        style.messageColor = type.textColor
        
        view.makeToast(message, position: .top, style: style, completion: completion)
    }
}

extension SZToastManagerImpl {
    func showMessage(_ message: String, completion: ((Bool) -> Void)? = nil) {
        self._showMessage(message, completion: completion)
    }
    
    func showError(_ message: String, completion: ((Bool) -> Void)? = nil) {
        self._showMessage(message, type: .error, completion: completion)
    }
    
    func showSuccess(_ message: String, completion: ((Bool) -> Void)?) {
        self._showMessage(message, type: .success, completion: completion)
    }
}
