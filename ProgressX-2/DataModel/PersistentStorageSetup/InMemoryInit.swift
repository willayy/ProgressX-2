//
//  InMemoryInit.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-09.
//

import Foundation
import CoreData

// This extension houses a function that staticly creates NSManagedObjects for an in-memory database
class InMemory {
    
    public static func initialize(context: NSManagedObjectContext) -> Void {
        CoreDataAccess.generatePreviewProfile(context)
        CoreDataAccess.generatePreviewBodyEntries(context)
        CoreDataAccess.generatePreviewCategories(context)
        CoreDataAccess.generatePreviewExercises(context)
        CoreDataAccess.generatePreviewRoutine(context)
    }
    
}
