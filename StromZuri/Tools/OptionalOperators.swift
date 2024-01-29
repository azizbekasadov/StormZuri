//
//  OptionalOperators.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import Foundation

infix operator ?= : AssignmentPrecedence
infix operator ?+ : AdditionPrecedence
infix operator ?+= : AssignmentPrecedence
infix operator =~ : LogicalConjunctionPrecedence

public func ?= <T>(target: inout T, newValue: T?) {
    if let unwrapped = newValue {
        target = unwrapped
    }
}

public func ?+ <T: AdditiveArithmetic>(lhs: T?, rhs: T?) -> T? {
    lhs.flatMap { x in rhs.map { y in x + y } }
}

public func ?+= <T: AdditiveArithmetic>(lhs: inout T?, rhs: T?) {
    lhs = lhs ?+ rhs
}

public func ?+ <T: StringProtocol>(lhs: Optional<T>, rhs: Optional<T>) -> String {
    [lhs, rhs].compactMap { $0 }.joined()
}


public func =~ (string:String, regex:String) -> Bool {
    string.range(of: regex, options: .regularExpression) != nil
}
