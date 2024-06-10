//
//  Persistence.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import CoreData
import UIKit

struct PersistenceController {
    
    static let shared = PersistenceController(inMemory: false)
    
    static let preview = {
        //MARK: Initialise a in-memory database with test values for the preview
        let result = PersistenceController(inMemory: true)
        let context = result.container.viewContext
        initInMemoryDb(context: context)
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool) {
        
        container = NSPersistentContainer(name: "ProgressX_2")
        
        let description = container.persistentStoreDescriptions.first!
        
        // Automatic migration for live database
        if !inMemory {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }
        
        // Make the container a in-memory database if the application is run as a test or as preview
        if inMemory {
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


