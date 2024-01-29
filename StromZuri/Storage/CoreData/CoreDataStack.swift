//
//  CoreDataStack.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

import CoreData

final class CoreDataStack {
    // MARK: Public vars
    public lazy var context = persistentContainer.viewContext

    // MARK: Private vars
    private var dataModelName = "DB" {
        didSet {
            persistentContainer = configurePersistentContainer()
        }
    }
    
    private var persistentContainer: NSPersistentContainer!

    public init(dbName: String) {
        dataModelName = dbName
        persistentContainer = configurePersistentContainer()
    }
    
    private func configurePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("Unable to load persistent stores: \(error)")
                fatalError(error.localizedDescription)
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        return container
    }
    
    public func saveContextIfChanged() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            debugPrint("Unable to save context: \(error)")
            fatalError(error.localizedDescription)
        }
    }
}

