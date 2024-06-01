//
//  DataRefining.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import Foundation
import CoreData
import UIKit

// This class contains method to sort through data fetched from the CoreData base. This file does not include fetching and inserting, look in Persistance for that.

class DataUtility {
    
    private static func isPreviewOrTest() -> Bool {
        let preview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        let test = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        return preview || test
    }
    
    // MARK: Data handling
    // Data handling are functions that uses object, or arrays of objects.
    
    public static func sortBwEntriesByDate(bwEntries: [BodyEntry]) -> [BodyEntry] {
        let sortedBwEntries = bwEntries
            .sorted(by: { $0.date! < $1.date! })
        return sortedBwEntries
    }
    
    public static func sortPersonralRecordsByDate(prs: [PersonalRecord]) -> [PersonalRecord] {
        let sortedPrs = prs
            .sorted(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return sortedPrs
    }
    
    public static func getHighestPrValue(data: [OneRepMax]) -> Double? {
        let highestValue: Double? = data.map { $0.load }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestPrValue(data: [TimeMax]) -> Double? {
        let highestValue: Double? = data.map { $0.time }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestPrValue(data: [MaxReps]) -> Int? {
        let highestValue: Int? = data.map { Int($0.reps) }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestBwValue(data: [BodyEntry]) -> Double? {
        let highestValue: Double? = data.map { $0.bodyWeight }.max() ?? nil
        return highestValue
    }
    
    public static func getLowestPrValue(data: [OneRepMax]) -> Double? {
        let lowestValue: Double? = data.map { $0.load }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestPrValue(data: [TimeMax]) -> Double? {
        let lowestValue: Double? = data.map { $0.time }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestPrValue(data: [MaxReps]) -> Int? {
        let lowestValue: Int? = data.map { Int($0.reps) }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestBwValue(data: [BodyEntry]) -> Double? {
        let lowestValue: Double? = data.map { $0.bodyWeight }.min() ?? nil
        return lowestValue
    }
    
    public static func get1RmPrs(exercise: RepBasedExercise) -> [OneRepMax]? {
        return exercise.oneRepMaxPrs?.array as? [OneRepMax]
    }
    
    public static func getMaxRepPrs(exercise: RepBasedExercise) -> [MaxReps]? {
        return exercise.maxRepPrs?.array as? [MaxReps]
        
    }
    
    public static func getTimePrs(exercise: TimeBasedExercise) -> [TimeMax]? {
        return exercise.timePrs?.array as? [TimeMax]
    }
    
    public static func getFirstPrDate(prs: [PersonalRecord]) -> String? {
        if prs.isEmpty { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = prs.min(by: { $0.achievedOnDate! < $1.achievedOnDate! })!.achievedOnDate
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
    public static func getLastPrDate(prs: [PersonalRecord]) -> String? {
        if prs.isEmpty { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = prs.min(by: { $0.achievedOnDate! > $1.achievedOnDate! })!.achievedOnDate
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
    public static func getLatestPrValue(data: [OneRepMax]) -> Double? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return latestInstance.load
        } else {
            return nil
        }
    }
    
    public static func getLatestPrValue(data: [MaxReps]) -> Int? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return Int(latestInstance.reps)
        } else {
            return nil
        }
    }
    
    public static func getLatestPrValue(data: [TimeMax]) -> Double? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return latestInstance.time
        } else {
            return nil
        }
    }
    
    public static func getEarliestValue(data: [OneRepMax]) -> Double? {
        if let earliestInstance = data.min(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return earliestInstance.load
        } else {
            return nil
        }
    }
    
    // MARK: Fetching / Saving to persistance
    // Data fetching / saving functions are functions that modify the persistant store in any way.
    
    /// Fetches profiles form the CoreData database as an array.
    /// - Returns:
    ///   [Profile]: the array of profiles
    public static func getProfileAsArray() -> [Profile] {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let request: NSFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        
        do {
            let fetchedProfiles: [Profile]  = try context.fetch(request) as [Profile]
            return fetchedProfiles
        } catch let error as NSError {
            fatalError("Error fetching Profile for doesProfileExist(): \(error), \(error.userInfo)")
        }
    }
    
    /// Checks for instances of Profile enteties in the CoreData database.
    /// - Returns:
    ///   True: if a single entity of Profile is found
    ///   False: if not a single entity of Profile is found
    public static func doesProfileExist() -> Bool {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        if (fetchedProfiles.first != nil) { return true } else { return false }
    }
    
    /// Verifies that the profile state of the CoreData database is correct, meaning does the database contain a single or no Profile entity.
    /// - Returns:
    ///   True: if a single or zero profile entities exist in the database
    ///   False: if more than 1 Profile entity exists
    public static func verifyProfileState() -> Bool {
        let fetchedProfiles: [Profile] = DataUtility.getProfileAsArray()
        if (fetchedProfiles.count < 2) { return true } else { return false }
    }
    
    /// Fetches the Profile entity from the CoreData database.
    /// - Returns:
    ///   Profile: if there exists a profile in the database
    ///   nil: if no profile exists in the database
    public static func getProfile() -> Profile? {
        let fetchedProfiles: [Profile] = DataUtility.getProfileAsArray()
        return fetchedProfiles.first
    }
    
    public static func getProfilePreview() -> Profile? {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let request: NSFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        
        do {
            let fetchedProfiles: [Profile]  = try context.fetch(request) as [Profile]
            return fetchedProfiles.first
        } catch let error as NSError {
            fatalError("Error fetching Profile for doesProfileExist(): \(error), \(error.userInfo)")
        }
    }
    
    /// Creates a Profile entity in the CoreData database
    /// - Parameters:
    ///   - userName: The username of the profile as a String
    ///   - birthDay: The birthday of the profile as a Date
    ///   - height: The height of the profile in any unit
    ///   - isMetric: Boolean to set if the profile uses metric or imperial units
    ///   - gender: The gender of the profile as a string, must be 'female' or 'male'
    public static func createProfile(userName:String, birthDay:Date, height:Double, isMetric:Bool, gender:String) -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let profile = Profile(context: context)
            .setValue_ch(userName, forKey: "userName")
            .setValue_ch(birthDay, forKey: "birthDay")
            .setValue_ch(height, forKey: "height")
            .setValue_ch(isMetric, forKey: "isMetric")
        if gender == "female" || gender == "male" {
            profile.setValue(gender, forKey: "gender")
        } else {
            fatalError("gender must be either 'male' or 'female' when creating profile")
        }
    }
    
    /// Creates and adds a bodyWeight entry to the profile
    /// - Parameters:
    ///   - dateAchieved: The date when the entry was logged
    ///   - weight: The logged weight
    ///   - chestCirc: (optional) the circumference of the chest in any unit
    ///   - waistCirc: (optional) the circumference of the waist in any unit
    ///   - upperArmCirc: (optional) the circumference of the upper arm in any unit
    ///   - lowerArmCirc: (optional) the circumference of the lower arm in any unit
    ///   - thighCirc: (optional) the circumference of the thigh in any unit
    ///   - calfCirc: (optional) the circumference of the calf in any unit
    /// - Returns: Void
    public static func addBodyWeightEntry(dateAchieved:Date, weight:Double, chestCirc:Double?=nil, waistCirc:Double?=nil, upperArmCirc:Double?=nil, lowerArmCirc:Double?=nil, thighCirc:Double?=nil, calfCirc:Double?=nil) -> Void {
        
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        guard let profile: Profile = DataUtility.getProfile() else {fatalError("A profile must be created before adding a bodyWeightEntry")}
        
        let bodyWeightEntry: BodyEntry = BodyEntry(context: context)
            .setValue_ch(dateAchieved, forKey: "date")
            .setValue_ch(weight, forKey: "bodyWeight")
            .setValue_ch(chestCirc, forKey: "chestCirc")
            .setValue_ch(waistCirc, forKey: "waistCirc")
            .setValue_ch(upperArmCirc, forKey: "uprArmCirc")
            .setValue_ch(lowerArmCirc, forKey: "lwrArmCirc")
            .setValue_ch(thighCirc, forKey: "thighCirc")
            .setValue_ch(calfCirc, forKey: "calfCirc")
        
        profile.addToBodyEntries(bodyWeightEntry)
    }
    
    public static func getBodyWeightEntriesAsArray() -> [BodyEntry] {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let request: NSFetchRequest = NSFetchRequest<BodyEntry>(entityName: "BodyEntry")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        
        do {
            let fetchedBodyEntries: [BodyEntry]  = try context.fetch(request) as [BodyEntry]
            return fetchedBodyEntries
        } catch let error as NSError {
            fatalError("Error fetching Profile for doesProfileExist(): \(error), \(error.userInfo)")
        }
    }
    
    /// Deletes a seleceted object
    /// - Parameter object: A NSManaged object that has been fetched from the database
    /// - Returns: Void
    public static func deleteNSManagedObject(object: NSManagedObject) -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        context.delete(object)
    }
    
    /// Deleetes all registered objects from the database
    /// - Returns: Void
    public static func wipeContext() -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        for obj in context.registeredObjects {
            context.delete(obj)
        }
    }
    
    /// Fetches all saved exercises from the CoreDatabase
    /// - Returns: Array of Exercises
    public static func getExercisesAsArray() -> [Exercise] {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let request: NSFetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        
        do {
            let fetchedExercises: [Exercise]  = try context.fetch(request) as [Exercise]
            return fetchedExercises
        } catch let error as NSError {
            fatalError("Error fetching Profile for doesProfileExist(): \(error), \(error.userInfo)")
        }
    }
    
    /// Generates a set of basic exercises as CoreDatabase entries
    /// - Returns: Void
    public static func generateBasicExerciseLibrary() -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        let jsonArray = try! JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]
        
        for json in jsonArray {
            var exercise: Exercise? = nil
            if json["type"] == "Reps" {exercise = RepBasedExercise(context: context)}
            else if json["type"] == "Time" {exercise = TimeBasedExercise(context: context)}
            exercise!
                .setValue_ch(json["name"], forKey: "exerciseName")
                .setValue(json["description"], forKey: "exerciseDesc")
        }
        
    }
    
    /// Add a one rep max personal record to an exercise that is based on doing a certain amount of reps.
    /// - Parameters:
    ///   - load: The weight used.
    ///   - exercise: The exercise this record was achieved on.
    /// - Returns: Void
    public static func addPersonalRecord(load: Double, exercise: RepBasedExercise) -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let pr = OneRepMax(context: context)
        pr.load = load
        pr.repBasedExercise = exercise
    }
    
    /// Add an amrap record to an exercise that is based on doing a certain amount of reps. This is mainly used for exercises considered "body weight" exercises but works on any rep based exercise.
    /// - Parameters:
    ///   - load: The load used. If the exercise is done with bodyweight, input current weight from profile.
    ///   - reps: The amount of reps finished.
    ///   - exercise: The exercise this record was achieved on.
    /// - Returns: Void
    public static func addPersonalRecord(load: Double, reps: Int, exercise: RepBasedExercise) -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let pr = MaxReps(context: context)
        pr.load = load
        pr.reps = 1
        pr.repBasedExercise = exercise
    }
    
    /// Add a time based record to an exercise that is based on doing a physical movement for a certain amount time under a load. This is mainly used for exercises that are "static", will work for any time based exercise.
    /// - Parameters:
    ///   - load: The load used. If the exercise is done with bodyweight, input current weight from profile.
    ///   - exercise: The exercise this record was achieved on.
    /// - Returns: Void
    public static func addPersonalRecord(load: Double, time exercise: TimeBasedExercise) -> Void {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        let pr = TimeMax(context: context)
        pr.load = load
        pr.timeBasedExercise = exercise
    }
    
    public static func save() {
        let p = PersistenceController.shared
        let context: NSManagedObjectContext = isPreviewOrTest() ? p.previewContainer.viewContext : p.container.viewContext
        
        do {
           try context.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error), \(error.userInfo)")
        }
    }
    
}
