//
//  AppPreferences.swift
//  StromZuri
//
//  Created by Azizbek Asadov on 25/01/24.
//

final class AppPreferences {
    static let shared: AppPreferences = .init()
    
    private(set) lazy var storage: StorageService = {
        let coreDataStack = CoreDataStack(dbName: GlobalConstants.dbName)
        return CoreDataStorageServiceImpl(coreDataStack: coreDataStack)
    }()

    private init() {} // Sort of DI Container
}

