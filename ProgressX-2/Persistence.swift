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
    ///     [Profile]: the array of profiles
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
    ///     True: if a single entity of Profile is found
    ///     False: if not a single entity of Profile is found
    public func doesProfileExist() -> Bool {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        if (fetchedProfiles.first != nil) { return true } else { return false }
    }
    
    /// Verifies that the profile state of the CoreData database is correct, meaning does the database contain a single or no Profile entity.
    /// - Returns:
    ///     True: if a single or zero profile entities exist in the database
    ///     False: if more than 1 Profile entity exists
    public func verifyProfileState() -> Bool {
        let fetchedProfiles: [Profile] = getProfileAsArray()
        if (fetchedProfiles.count < 2) { return true } else { return false }
    }
    
    /// Fetches the Profile entity from the CoreData database.
    /// - Returns:
    ///     Profile: if there exists a profile in the database
    ///     nil: if no profile exists in the database
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
    public func createProfile(userName:String, birthDay:Date, height:Int, isMetric:Bool, gender:String) -> Void {
        let profile = Profile(context: container.viewContext)
        profile.setValue(userName, forKey: "userName")
        profile.setValue(birthDay, forKey: "birthDay")
        profile.setValue(height, forKey: "height")
        profile.setValue(isMetric, forKey: "isMetric")
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
    public func addBodyWeightEntry(dateAchieved:Date, weight:Double, chestCirc:Double?=nil, waistCirc:Double?=nil, upperArmCirc:Double?=nil, lowerArmCirc:Double?=nil, thighCirc:Double?=nil, calfCirc:Double?=nil) {
        
        guard let profile: Profile = getProfile() else {fatalError("A profile must be created before adding a bodyWeightEntry")}
        
        let bodyWeightEntry = BodyEntry(context: container.viewContext)
        
        bodyWeightEntry.setValue(dateAchieved, forKey: "date")
        bodyWeightEntry.setValue(weight, forKey: "bodyWeight")
        bodyWeightEntry.setValue(chestCirc, forKey: "chestCirc")
        bodyWeightEntry.setValue(waistCirc, forKey: "waistCirc")
        bodyWeightEntry.setValue(upperArmCirc, forKey: "uprArmCirc")
        bodyWeightEntry.setValue(lowerArmCirc, forKey: "lwrArmCirc")
        bodyWeightEntry.setValue(thighCirc, forKey: "thighCirc")
        bodyWeightEntry.setValue(calfCirc, forKey: "calfCirc")
        
        profile.addToBodyEntries(bodyWeightEntry)
    }
    
}
