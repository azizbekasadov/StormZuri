//
//  UIConfigurable.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

@objc
public protocol UIConfigurable: AnyObject {
    @objc
    optional func setupUI()
    
    @objc
    optional func setupLayout()
}
