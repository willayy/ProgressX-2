//
//  Checkers.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

/// Extensions that has functions who check if things exists or are in a certain state within the CoreData model.
extension CoreDataAccess {
    
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
    
    /// Checks if there exists duplicate names among the profiles saved.
    /// - Parameter context: The NSManagedObjectContext
    /// - Returns: True if two profiles have the same name, else false
    public static func profileNameIsUnique(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest = Profile.fetchRequest()
        let results = fetch(context, fetchRequest: fetchRequest)
        let profileNames = results.map { $0.profileUserName }
        let profileNameSet = Set(profileNames)
        if profileNames.count != profileNameSet.count {
            return false
        } else {
            return true
        }
    }
    
    /// Checks if there exists duplicate names among the exercises saved.
    /// - Parameter context: The NSManagedObjectContext.
    /// - Returns: True if two exercises have the same name, else false.
    public static func exerciseNameIsUnique(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest = Exercise.fetchRequest()
        let results = fetch(context, fetchRequest: fetchRequest)
        let exerciseNames = results.map { $0.exerciseName }
        let exerciseNameSet = Set(exerciseNames)
        if exerciseNames.count != exerciseNameSet.count {
            return false
        } else {
            return true
        }
    }
    
    /// Checks if there exists duplicate names among the categories saved.
    /// - Parameter context: The NSManagedObjectContext
    /// - Returns: True if two exercise categories have the same name, else false.
    public static func categoryNameIsUnique(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest = ExerciseCategory.fetchRequest()
        let results = fetch(context, fetchRequest: fetchRequest)
        let categoryNames = results.map { $0.categoryName }
        let categoryNameSet = Set(categoryNames)
        if categoryNames.count != categoryNameSet.count {
            return false
        } else {
            return true
        }
    }
    
    /// Checks if there exists duplicate names among the routines saved.
    /// - Parameter context: The NSManagedObjectContext.
    /// - Returns: True if two routines have the same name, else false.
    public static func routineNameIsUnique(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest = Routine.fetchRequest()
        let results = fetch(context, fetchRequest: fetchRequest)
        let routineNames = results.map { $0.timePeriodName }
        let routineNameSet = Set(routineNames)
        if routineNames.count != routineNameSet.count {
            return false
        } else {
            return true
        }
    }
    
}
