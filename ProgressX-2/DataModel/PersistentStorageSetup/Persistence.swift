//
//  Persistence.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import CoreData

struct PersistenceController {
        
    private let container: NSPersistentContainer

    init(inMemory: Bool) {
        
        container = NSPersistentContainer(name: "ProgressX_2")
        
        let description = container.persistentStoreDescriptions.first!
        
        // Automatic migration for app production database
        if !inMemory {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        if inMemory {
            // This creates an in-memory database
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Flag to check if unitTests are being run
    private static let TESTING: Bool = {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }()
    
    /* The persistence controller intended for the app during run-time and production.
     To make this work during testing without throwing warnings the shared Persistence controller
     is aliased to the preview one during testing. If this isnt done two identical DataModels will
     be created during testing which throws warnings since all entities will be duplicated */
    private static let shared = {
        if TESTING {
          return preview
        } else {
          return PersistenceController(inMemory: false)
        }
    }()
    
    // The persistence ontroller intended for the app during developement with the canvas view and testing
    private static let preview = {
        // Initialize as in-memory
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        // Populate with in-memory data
        InMemory.initialize(context: context)
        CoreDataAccess.save(context)
        return result
    }()
    
    /// Accessor for the preview viewContext
    public static var previewViewContext: NSManagedObjectContext {
        return preview.container.viewContext
    }
    
    /// Accessor for the live viewContext
    public static var viewContext: NSManagedObjectContext {
        return shared.container.viewContext
    }
    
}


