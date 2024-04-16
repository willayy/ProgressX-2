//
//  Persistence.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ProgressX_2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    
    public func doesProfileExist() -> Bool {
        let request: NSFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        let context = container.viewContext
        
        do {
            let fetchedProfiles: [Profile]  = try context.fetch(request) as [Profile]
            if (fetchedProfiles.first != nil) { return true } else { return false }
        } catch {
            fatalError("Error fetching Profile for doesProfileExist()")
        }
    }
    
}
