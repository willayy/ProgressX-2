//
//  Persistence.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import CoreData

struct PersistenceController {
    
    // The persistence controller intended for the app during run-time testing and production
    static let shared = PersistenceController(inMemory: false)
    
    // The persistence ontroller intended for the app during developement with the canvas view
    // and when running tests.
    static let preview = {
        // Initialize as in-memory
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        // Populate with in-memory data
        PersistenceController.initInMemoryDb(context: context)
        PersistenceController.save(context)
        return result
    }()
    
    let container: NSPersistentContainer

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
    
}


