//
//  StorageService.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreData

public protocol StorageService {
    var context: NSManagedObjectContext { get }

    // MARK: Write
    func write()

    // MARK: Fetch
    func fetchLast<T: Storagable>(type: T.Type) -> T?
    
    func fetch<T: Storagable>(type: T.Type) -> [T]?

    func fetch<T: Storagable>(type: T.Type, predicate: NSPredicate) -> [T]?

    func fetch<T: Storagable>(type: T.Type, sortDescriptors: [NSSortDescriptor]) -> [T]?

    func fetch<T: Storagable>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) -> [T]?

    func fetch<T: Storagable>(type: T.Type, configuration: FetchConfiguration) -> [T]?

    // MARK: Remove
    func remove(_ object: Storagable)

    func remove<S: Sequence>(_ objects: S) where S.Iterator.Element: Storagable

    func removeAll<T: Storagable>(type: T.Type)

    func removeAll<T: Storagable>(type: T.Type, predicate: NSPredicate)
}

