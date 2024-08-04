//
//  PersistenceGet.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

/// Extensions that has getter functions for things that are often accessed from the CoreData model and warrant a shortcut.
extension PersistenceController {
    
    /// Gets an exercise that has the matching exerciseName
    /// - Parameters:
    ///   - context: NSManagedObjectContext
    ///   - name: A string name that should match the exercises .exerciseName property.
    /// - Returns: Returns a matching exercise or nil (if no matches are found)
    public static func getExercise(_ context: NSManagedObjectContext, name: String) -> Exercise? {
        let fetchRequest: NSFetchRequest = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@", name)
        let results = fetch(context, fetchRequest: fetchRequest)
        return results.first ?? nil
    }
    
    /// Gets the Profile if one is created.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: A Profile object if one has been created, else nil.
    public static func getProfile(_ context: NSManagedObjectContext) -> Profile? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        return fetchResult.first
    }
    
    /// Gets the weightUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getWeightUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "kg's" : "lbs"}
    }
    
    /// Gets the lengthUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getLengthUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "cm" : "ft"}
    }
    
    /// Gets the latest PersonalRecord achieved on some exercise..
    /// - Parameters:
    ///   - context: A NSManagedObjectContext from a peristent container.
    ///   - exercise: An NSManagedObject subclass Exercise object.
    ///   - prType: The type of the PR, this can be "onerepmax" or "maxreps" for a rep based exercise. For a time based exercise it can only be "timemax"
    /// - Returns: The latest achieved PR of an Exercise.
    public static func getLatestPersonalRecord(_ context: NSManagedObjectContext, exercise: Exercise, prType: String) -> PersonalRecord? {
        let fetchRequest: NSFetchRequest<PersonalRecord> = PersonalRecord.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise),
                NSPredicate(format: "prType == %@", prType)
            ]
        )
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let latest = fetchResult.max(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return latest
    }
    
    /// Gets the latest BodyEntry.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: The latest achieved BodyEntry
    public static func getLatestBodyEntry(_ context: NSManagedObjectContext) -> BodyEntry? {
        let fetchRequest: NSFetchRequest<BodyEntry> = BodyEntry.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let latest = fetchResult.max(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return latest
    }
    
}
