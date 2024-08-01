//
//  PersistenceCheck.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

/// Extensions that has functions who check if things exists or are in a certain state within the CoreData model.
extension PersistenceController {
    
    /// Checks if a Profile exists. That is, is there more than 0 Profiles saved to the persistent store.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: Yes if profile exists, No if it doesnt.
    public static func profileExists(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        return fetchResult.count > 0
    }
    
    /// Checks if the basic routine has been generated.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: True if it has been generated, otherwise it returns false.
    public static func basicRoutineExists(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest = Routine.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "timePeriodName == %@", "Example routine")
        let results = fetch(context, fetchRequest: fetchRequest)
        return results.count == 1
    }
    
    /// Checks if the set of basic exercises has been generated.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: True if they are generated, false otherwise.
    public static func basicExercisesExist(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        return fetchResult.count > 0
    }
    
}
