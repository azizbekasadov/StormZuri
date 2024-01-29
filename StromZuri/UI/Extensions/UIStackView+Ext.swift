//
//  UIStackView+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

public extension UIStackView {
    
    @discardableResult
    func removeArrandedViews() -> Self {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        return self
    }
    
    @discardableResult
    func addArrangedViews(_ views: UIView...) -> Self {
        views.forEach { addArrangedSubview($0) }
        return self
    }
}

