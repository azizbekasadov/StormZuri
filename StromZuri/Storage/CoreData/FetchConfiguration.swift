//
//  FetchConfiguration.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreData

public struct FetchConfiguration {
    public let predicate: NSPredicate?
    public let sortDescriptors: [NSSortDescriptor]?
    public let fetchLimit: Int?
    public let fetchOffset: Int?

    public init(
        predicate: NSPredicate? = nil,
         sortDescriptors: [NSSortDescriptor]? = nil,
         fetchLimit: Int? = nil,
         fetchOffset: Int? = nil
    ) {
        self.predicate = predicate
        self.sortDescriptors = sortDescriptors
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
    }
}

