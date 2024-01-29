//
//  CDStorageServiceImpl.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreData

final class CoreDataStorageServiceImpl: StorageService {
    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    var context: NSManagedObjectContext {
        return coreDataStack.context
    }

    func write() {
        coreDataStack.saveContextIfChanged()
    }

    func fetchLast<T: Storagable>(type: T.Type) -> T? {
        return fetchAll(type: T.self)?.last
    }

    func fetch<T: Storagable>(type: T.Type) -> [T]? {
        return fetchAll(type: T.self)
    }

    func fetch<T: Storagable>(
        type: T.Type, 
        predicate: NSPredicate
    ) -> [T]? {
        let configuration = FetchConfiguration(predicate: predicate)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(
        type: T.Type,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]? {
        let configuration = FetchConfiguration(sortDescriptors: sortDescriptors)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(
        type: T.Type,
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor]
    ) -> [T]? {
        let configuration = FetchConfiguration(predicate: predicate, sortDescriptors: sortDescriptors)
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func fetch<T: Storagable>(type: T.Type, configuration: FetchConfiguration) -> [T]? {
        return fetchAll(type: T.self, fetchConfiguration: configuration)
    }

    func remove(_ object: Storagable) {
        coreDataStack.context.delete(object)
    }

    func remove<S: Sequence>(_ objects: S) where S.Iterator.Element: Storagable {
        objects.forEach { coreDataStack.context.delete($0) }
    }

    func removeAll<T: Storagable>(type: T.Type) {
        guard let fetchedObjects = fetchAll(type: T.self) else {
            return
        }

        remove(fetchedObjects)
    }

    func removeAll<T: Storagable>(type: T.Type, predicate: NSPredicate) {
        let configuration = FetchConfiguration(predicate: predicate)
        guard let fetchedObjects = fetchAll(type: T.self, fetchConfiguration: configuration) else {
            return
        }

        remove(fetchedObjects)
    }
}

extension CoreDataStorageServiceImpl {
    private func createRequest<T: Storagable>(withResultType type: T.Type) throws -> NSFetchRequest<T> {
        if let name = T.entity().name {
            return NSFetchRequest(entityName: name)
        } else {
            throw CoreDataError.requestCreationFail
        }
    }

    private func fetchAll<T: Storagable>(
        type: T.Type,
        fetchConfiguration: FetchConfiguration? = nil
    ) -> [T]? {
        do {
            let request = try createRequest(withResultType: T.self)
            request.predicate = fetchConfiguration?.predicate
            request.sortDescriptors = fetchConfiguration?.sortDescriptors
            request.fetchLimit ?= fetchConfiguration?.fetchLimit
            request.fetchOffset ?= fetchConfiguration?.fetchOffset
            let result = try coreDataStack.context.fetch(request)
            return result.isEmpty ? nil : result
        } catch {
            return nil
        }
    }
}
