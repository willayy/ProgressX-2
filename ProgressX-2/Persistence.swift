//
//  Persistence.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import CoreData
import UIKit

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
    
    public func save() {
        do {
           try container.viewContext.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error), \(error.userInfo)")
        }
    }
    
}

extension PersistenceController {
    
    /// Fetches profiles form the CoreData database as an array.
    /// - Returns:
    ///   [Profile]: the array of profiles
    public func getProfileAsArray() -> [Profile] {
        let request: NSFetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        let context = container.viewContext
        
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
    public func doesProfileExist() -> Bool {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        if (fetchedProfiles.first != nil) { return true } else { return false }
    }
    
    /// Verifies that the profile state of the CoreData database is correct, meaning does the database contain a single or no Profile entity.
    /// - Returns:
    ///   True: if a single or zero profile entities exist in the database
    ///   False: if more than 1 Profile entity exists
    public func verifyProfileState() -> Bool {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        if (fetchedProfiles.count < 2) { return true } else { return false }
    }
    
    /// Fetches the Profile entity from the CoreData database.
    /// - Returns:
    ///   Profile: if there exists a profile in the database
    ///   nil: if no profile exists in the database
    public func getProfile() -> Profile? {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        return fetchedProfiles.first
    }
    
    /// Creates a Profile entity in the CoreData database
    /// - Parameters:
    ///   - userName: The username of the profile as a String
    ///   - birthDay: The birthday of the profile as a Date
    ///   - height: The height of the profile in any unit
    ///   - isMetric: Boolean to set if the profile uses metric or imperial units
    ///   - gender: The gender of the profile as a string, must be 'female' or 'male'
    public func createProfile(userName:String, birthDay:Date, height:Double, isMetric:Bool, gender:String) -> Void {
        let profile = Profile(context: container.viewContext)
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
    public func addBodyWeightEntry(dateAchieved:Date, weight:Double, chestCirc:Double?=nil, waistCirc:Double?=nil, upperArmCirc:Double?=nil, lowerArmCirc:Double?=nil, thighCirc:Double?=nil, calfCirc:Double?=nil) -> Void {
        
        guard let profile: Profile = getProfile() else {fatalError("A profile must be created before adding a bodyWeightEntry")}
        
        let bodyWeightEntry: BodyEntry = BodyEntry(context: container.viewContext)
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
    
    public func getBodyWeightEntriesAsArray() -> [BodyEntry] {
        let request: NSFetchRequest = NSFetchRequest<BodyEntry>(entityName: "BodyEntry")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        let context = container.viewContext
        
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
    public func deleteNSManagedObject(object: NSManagedObject) -> Void {
        container.viewContext.delete(object)
    }
    
    /// Deleetes all registered objects from the database
    /// - Returns: Void
    public func wipeCoreDataBase() -> Void {
        for obj in container.viewContext.registeredObjects {
            container.viewContext.delete(obj)
        }
    }
    
    /// Fetches all saved exercises from the CoreDatabase
    /// - Returns: Array of Exercises
    public func getExercisesAsArray() -> [Exercise] {
        let request: NSFetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        request.shouldRefreshRefetchedObjects = true
        request.includesPropertyValues = true
        let context = container.viewContext
        
        do {
            let fetchedExercises: [Exercise]  = try context.fetch(request) as [Exercise]
            return fetchedExercises
        } catch let error as NSError {
            fatalError("Error fetching Profile for doesProfileExist(): \(error), \(error.userInfo)")
        }
    }
    
    /// Generates a set of basic exercises as CoreDatabase entries
    /// - Returns: Void
    public func generateBasicExerciseLibrary() -> Void {
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        let jsonArray = try! JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]
        
        for json in jsonArray {
            var exercise: Exercise? = nil
            if json["type"] == "reps" {exercise = RepBasedExercise(context: container.viewContext)}
            else if json["type"] == "time" {exercise = TimeBasedExercise(context: container.viewContext)}
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
    public func addPersonalRecord(load: Double, exercise: RepBasedExercise) -> Void {
        let pr = OneRepMax(context: container.viewContext)
        pr.load = load
        pr.repBasedExercise = exercise
    }
    
    /// Add an amrap record to an exercise that is based on doing a certain amount of reps. This is mainly used for exercises considered "body weight" exercises but works on any rep based exercise.
    /// - Parameters:
    ///   - load: The load used. If the exercise is done with bodyweight, input current weight from profile.
    ///   - reps: The amount of reps finished.
    ///   - exercise: The exercise this record was achieved on.
    /// - Returns: Void
    public func addPersonalRecord(load: Double, reps: Int, exercise: RepBasedExercise) -> Void {
        let pr = MaxReps(context: container.viewContext)
        pr.load = load
        pr.reps = 1
        pr.repBasedExercise = exercise
    }
    
    /// Add a time based record to an exercise that is based on doing a physical movement for a certain amount time under a load. This is mainly used for exercises that are "static", will work for any time based exercise.
    /// - Parameters:
    ///   - load: The load used. If the exercise is done with bodyweight, input current weight from profile.
    ///   - exercise: The exercise this record was achieved on.
    /// - Returns: Void
    public func addPersonalRecord(load: Double, time exercise: TimeBasedExercise) -> Void {
        let pr = TimeMax(context: container.viewContext)
        pr.load = load
        pr.timeBasedExercise = exercise
    }
    
}

