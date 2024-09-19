//
//  PersistenceAccess.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

class CoreDataAccess {
    
    /// Executing a NSFetchRequests of type T
    /// - Parameters:
    ///   - context: NSManagedObjectContext.
    ///   - fetchRequest: The fetch request to be executed.
    /// - Returns: Array of object of type T
    public static func fetch<T: NSManagedObject>(_ context: NSManagedObjectContext, fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("\(error) \(error.userInfo)")
        }
    }
    
    /// Saves changes to the selected context.
    /// - Parameter context: A NSManagedObjectContext
    public static func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    /// Deletes a NSManagedObject from the context
    /// - Parameters:
    ///   - context: A NSManagedObjectContext
    ///   - object: A NSManagedObject
    public static func delete(_ context: NSManagedObjectContext, object: NSManagedObject) {
       context.delete(object)
    }
    
    /// Deletes all saved Objects from the context
    /// - Parameter context: A NSManagedObjectContext
    public static func deleteEverything(_ context: NSManagedObjectContext) {
        for obj in context.registeredObjects {
            delete(context, object: obj)
        }
    }
    
}
