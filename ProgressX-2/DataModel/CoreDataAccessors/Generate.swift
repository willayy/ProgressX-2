//
//  Generate.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData
import UIKit

/// Extension of CoreDataAccess
extension CoreDataAccess {
    
    // MARK: Helper functions
    
    /// Gets a bundled asset by its name.
    private static func getAsset(_ assetName: String) -> NSDataAsset {
        guard let asset = NSDataAsset(name: assetName, bundle: Bundle.main) else {
            fatalError("Could not find \(assetName) data asset")
        }
        return asset
    }
    
    /// Transforms a NSDataAsset JSON file to a dictionary.
    private static func transformAsset(_ asset: NSDataAsset) -> [[String : Any]] {
        let transformedAsset = try! JSONSerialization.jsonObject(
            with: asset.data,
            options: JSONSerialization.ReadingOptions.allowFragments
        ) as! [[String: Any]]
        return transformedAsset
    }
    
    /// Generates an Exercise from JSON data.
    private static func generateExercise(jsonDict: [String : Any], _ context: NSManagedObjectContext) -> Void {
        
        let name = jsonDict["name"]! as! String
        
        let description = jsonDict["description"]! as! String
        
        let type = jsonDict["type"]! as! String
        
        let categories: [String] = jsonDict["categories"]! as! [String]
        
        let exercise = Exercise(
            context,
            name: name,
            description: description,
            type: type
        )
        
        for category in categories {
            
            let fetchRequest = ExerciseCategory.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)
            
            let category = fetch(context, fetchRequest: fetchRequest).first!
            
            exercise.addToCategories(category)
            
            category.addToExercise(exercise)
        }
    }
    
    /// Gets the children of a JSON derived dictionary.
    private static func getChildren(jsonDict: [String : Any]) -> [[String : Any]] {
        return jsonDict["children"] as! [[String : Any]]
    }
    
    /// Generates a Routine from JSON data.
    private static func generateRoutine(jsonDict: [String : Any], _ context: NSManagedObjectContext) -> Void {
    
        // Create the routine
        let routine = Routine(context, json: jsonDict)
        
        // Get the template cycle JSON, special case since there is only a single TemplateCycle
        let templateCycleJSON = (jsonDict["children"] as! [[String : Any]])[0]
        
        // Create the templateCycle and trainingCycle
        let templateCycle = TemplateCycle(context, routine: routine, json: templateCycleJSON)
        let trainingCycle = TrainingCycle(context, routine: routine)
        
        let templateWeeksJSON = getChildren(jsonDict: templateCycleJSON)
        
        // Iterate over all weeks in templatecycle
        for templateWeekJSON in templateWeeksJSON {
            
            // Create the templateWeek and trainingWeek
            let templateWeek = TemplateWeek(context, templateCycle: templateCycle, json: templateWeekJSON)
            let trainingWeek = TrainingWeek(context, trainingCycle: trainingCycle, templateWeek: templateWeek)
            
            let templateSessionsJSON = getChildren(jsonDict: templateWeekJSON)
            
            // Iterate over all sessions in templateWeek
            for templateSessionJSON in templateSessionsJSON {
                
                // Create the templateSession and trainingSession
                let templateSession = TemplateSession(context, templateWeek: templateWeek, json: templateSessionJSON)
                let trainingSession = TrainingSession(context, trainingWeek: trainingWeek, templateSession: templateSession)
                
                let templateSetsJSON = getChildren(jsonDict: templateSessionJSON)
                
                // Iterate over all sets in templateSession
                for templateSetJSON in templateSetsJSON {
                    
                    let templateSet = TemplateSet(context, templateSession: templateSession, json: templateSetJSON)
                    _ = TrainingSet(context, trainingSession: trainingSession, templateSet: templateSet)
                    
                    let setThresholdsJSON = getChildren(jsonDict: templateSetJSON)
                    
                    // Iterate over all thresholds in templateSet
                    for setThresholdJSON in setThresholdsJSON {
                        
                        _ = SetThreshold(context, templateSet: templateSet, json: setThresholdJSON)
                        
                    }
                }
            }
        }
    }
        
    // MARK: Preview in-memory database generating functions
    
    /// Generates categories for the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewCategories(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewExerciseCategories")
        
        let jsonArray = transformAsset(asset)
        
        // JSON Array contains a single object with an attribute that is an array of strings.
        let names = jsonArray[0]["categoryNames"] as! [String]
        
        for name in names {
            _ = ExerciseCategory(
                context,
                name: name
            )
        }
    }
    
    /// Generates PersonalRecords for the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewPersonalRecords(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewPersonalRecords")
        
        let jsonArray = transformAsset(asset)
        
        /* Just use this offset instead of relying on dates in the JSON, 
         it becomes less data that we need to write by hand
         and in the end it's just for the preview anyway */
        var dateOffset = 1000000
        
        for json in jsonArray {
            
            let exercise = CoreDataAccess.getExercise(context, name: json["exercise"] as! String)!
            
            _ = PersonalRecord(
                context,
                exercise: exercise,
                weightLoad: json["load"] as! Double,
                quantity: json["quantity"] as! Double,
                date: Date() - TimeInterval(dateOffset),
                type: json["prType"] as! String
            )
            
            dateOffset += 1000000
            
        }
        
    }
    
    /// Generates exercises for the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewExercises(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewExercises")
        
        let jsonArray = transformAsset(asset)
        
        for json in jsonArray {
            
            generateExercise(jsonDict: json, context)
            
        }
    }
    
    /// Generates a profile for the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewProfile(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewProfile")
        
        let jsonArray = transformAsset(asset)
        
        let profile = jsonArray[0]
        
        _ = Profile(
            context,
            userName: profile["profileUserName"] as! String,
            gender: profile["gender"] as! String,
            height: profile["height"] as! Double,
            isMetric: (profile["isMetric"] as! Int) == 1,
            smallestPlate: profile["smallestPlate"] as! Double,
            birthDay: Date(timeIntervalSince1970: TimeInterval((profile["birthDay"] as! Int)))
        )
        
    }
    
    /// Generates body entries for the profile in the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewBodyEntries(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewBodyEntries")
        
        let jsonArray = transformAsset(asset)
        
        let fetchRequest: NSFetchRequest = Profile.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "profileUserName == %@", "TestProfile")
        
        let results = fetch(context, fetchRequest: fetchRequest)
        
        let profile = results.first!
        
        for json in jsonArray {
            _ = BodyEntry(
                context,
                profile: profile,
                bodyWeight: json["bodyWeight"] as! Double,
                date: Date(timeIntervalSince1970: TimeInterval((json["date"] as! Int)))
            )
        }
        
    }
    
    /// Generates a routines for the in-memory database.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generatePreviewRoutine(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewRoutine")
        
        let jsonArray = transformAsset(asset)
        
        let jsonRoutine = jsonArray.first!
        
        generateRoutine(jsonDict: jsonRoutine, context)
    }
    
    // MARK: Live database generating functions
    
    /// Generates a set of basic exercises from a data asset as CoreData entries
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateStarterExerciseLibrary(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("Exercises")
        
        let jsonArray = transformAsset(asset)
        
        for json in jsonArray {
            
            generateExercise(jsonDict: json, context)
            
        }
    }
    
    /// Generates a set of exerciseCategories from a data asset as CoreData entries.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateExerciseCategories(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("ExerciseCategories")
        
        let jsonArray = transformAsset(asset)
        
        // JSON Array contains a single object with an attribute that is an array of strings.
        let names = jsonArray[0]["categoryName"] as! [String]
        
        for name in names {
            _ = ExerciseCategory(
                context,
                name: name
            )
        }
    }
    
    /// Generates a set of popular starter routines based of the starter exercises generated.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateStarterRoutines(_ context: NSManagedObjectContext) -> Void {
        
        /* MARK: WARNING,
        when adding new routine assets here make sure to also add them
        in the basicRoutinesExists(_ context: NSManagedObjectContext) function
        in CoreDataAccessors/Checkers.swift */
        
        // Fill this list with routine assets
        let assets = [
            getAsset("Metallicdpas-PPL-Routine")
        ]
        
        // Transform every asset into a routine
        for asset in assets {
            
            let jsonArray = transformAsset(asset)
            
            let jsonRoutine = jsonArray.first!
            
            generateRoutine(jsonDict: jsonRoutine, context)
            
        }
        
    }
        
}
