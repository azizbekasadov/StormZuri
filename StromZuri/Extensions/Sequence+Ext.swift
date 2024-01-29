//
//  Sequence+Ext.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

extension Sequence {
    subscript<R>(range: R) -> [Element] where R: RangeExpression, R.Bound == Int {
        var result: [Element] = []
        
        for (index, element) in self.enumerated() {
            if range.contains(index) {
                result.append(element)
            }
        }
        return result
    }
}
