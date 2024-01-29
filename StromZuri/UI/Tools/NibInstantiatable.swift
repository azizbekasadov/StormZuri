//
//  NibInstantiatable.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import UIKit

public protocol NibInstantiatable {
    static func nibName() -> String
}

public extension NibInstantiatable {
    static func nibName() -> String {
        return String(describing: self)
    }
}

public extension NibInstantiatable where Self: UIView {
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        return nib!.first as! Self
    }
}

