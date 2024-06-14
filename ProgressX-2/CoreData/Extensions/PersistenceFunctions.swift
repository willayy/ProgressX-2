//
//  PersistenceFunctions.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-13.
//

import Foundation
import CoreData
import UIKit

// This extension contain static convinience functions for managing data from the persistent store
extension PersistenceController {
    
    /// Convenience function for fetching, this function is not intended for SwiftUI views.
    /// - Parameters:
    ///   - context: The context to fetch from.
    ///   - fetchRequest: The fetch request.
    /// - Returns: Array of object of type T
    public static func fetch<T: NSManagedObject>(_ context: NSManagedObjectContext, fetchRequest: NSFetchRequest<T>) -> [T] {
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            fatalError("\(error) \(error.userInfo)")
        }
    }
    
    public static func save(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error), \(error.userInfo)")
        }
    }
    
    public static func save_throws(_ context: NSManagedObjectContext) throws {
        try context.save()
    }
    
    public static func delete(_ context: NSManagedObjectContext, object: NSManagedObject) {
       context.delete(object)
    }
    
    /// Generates a set of basic exercises as CoreDatabase entries
    /// - Returns: Void
    public static func generateBasicExerciseLibrary(_ context: NSManagedObjectContext) -> Void {
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        let jsonArray = try! JSONSerialization.jsonObject(
            with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments
        ) as! [[String: String]]
        
        for json in jsonArray {
            if json["type"] == "Reps" {
                _ = createExercise(context, name: json["name"]!, desc: json["description"]!, type: "reps")
            }
            else if json["type"] == "Time" {
                _ = createExercise(context, name: json["name"]!, desc: json["description"]!, type: "time")
            }
        }
    }
    
    /// Staticly check if a Profile exists.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: Yes if profile exists, No if it doesnt.
    public static func profileExists(_ context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        return fetchResult.count > 0
    }
    
    /// Staticly get the weightUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getWeightUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "kg's" : "lbs"}
    }
    
    /// Staticly get the lengthUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getLengthUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "cm" : "ft"}
    }
    
    public static func createExercise(_ context: NSManagedObjectContext, name: String, desc: String, type: String) -> Exercise {
        let exercise: Exercise = Exercise(context: context)
        exercise.exerciseName = name
        exercise.exerciseDesc = desc
        exercise.exerciseType = type
        return exercise
    }
    
    public static func createPersonalRecord(_ context: NSManagedObjectContext, exercise: Exercise, wl: Double, q: Double, date: Date, type: String) -> PersonalRecord {
        let personalRecord = PersonalRecord(context: context)
        personalRecord.prQuantity = q
        personalRecord.weightLoad = wl
        personalRecord.achievedOnDate = date
        personalRecord.prType = type
        personalRecord.exercise = exercise
        return personalRecord
    }
    
    public static func createBodyEntry(_ context: NSManagedObjectContext, profile: Profile, weight: Double, date: Date) -> BodyEntry {
        let bodyEntry = BodyEntry(context: context)
        bodyEntry.bodyWeight = weight
        bodyEntry.achievedOnDate = date
        bodyEntry.profile = profile
        return bodyEntry
    }
    
}
