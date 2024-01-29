//
//  Collection+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
