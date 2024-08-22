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
    
    private static func getAsset(_ assetName: String) -> NSDataAsset {
        guard let asset = NSDataAsset(name: assetName, bundle: Bundle.main) else {
            fatalError("Could not find \(assetName) data asset")
        }
        return asset
    }
    
    private static func transformAsset(_ asset: NSDataAsset) -> [[String : Any]] {
        let transformedAsset = try! JSONSerialization.jsonObject(
            with: asset.data,
            options: JSONSerialization.ReadingOptions.allowFragments
        ) as! [[String: Any]]
        return transformedAsset
    }
    
    private static func generateExercise(data: [String : Any], _ context: NSManagedObjectContext) -> Void {
        
        let name = data["name"]! as! String
        
        let description = data["description"]! as! String
        
        let type = data["type"]! as! String
        
        let categories: [String] = data["categories"]! as! [String]
        
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
    
    private static func generateRoutine(data: [String : Any], _ context: NSManagedObjectContext) -> Void {
        
        

    }
    
    // MARK: Preview
    
    public static func generatePreviewCategories(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewExerciseCategories")
        
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
    
    public static func generatePreviewExercises(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewExercises")
        
        let jsonArray = transformAsset(asset)
        
        for json in jsonArray {
            
            generateExercise(data: json, context)
            
        }
    }
    
    public static func generatePreviewProfile(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewProfile")
        
        let jsonArray = transformAsset(asset)
        
        let profile = jsonArray[0]
        
        _ = Profile(
            context,
            userName: profile["userName"] as! String,
            gender: profile["gender"] as! String,
            height: profile["height"] as! Double,
            isMetric: (profile["isMetric"] as! Int) == 1,
            smallestPlate: profile["smallestPlate"] as! Double,
            birthDay: Date(timeIntervalSince1970: TimeInterval((profile["birthDay"] as! Int)))
        )
        
    }
    
    public static func generatePreviewBodyEntries(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewBodyEntries")
        
        let jsonArray = transformAsset(asset)
        
        let fetchRequest: NSFetchRequest = Profile.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "userName == %@", "TestProfile")
        
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
    
    public static func generatePreviewPersonalRecords(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("PreviewPersonalRecords")
        
        let jsonArray = transformAsset(asset)
        
        for json in jsonArray {
            
            let exerciseName = json["exerciseName"] as! String
            
            let fetchRequest = Exercise.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "exerciseName == %@", exerciseName)
            
            let results = fetch(context, fetchRequest: fetchRequest)
            
            let exercise = results.first!
            
            _ = PersonalRecord(
                context,
                exercise: exercise,
                weightLoad: json["weightLoad"] as! Double,
                quantity: json["quantity"] as! Double,
                date: Date(timeIntervalSince1970: TimeInterval((json["date"] as! Int))),
                type: json["type"] as! String
            )
            
        }
        
    }
    
    public static func generatePreviewRoutine(_ context: NSManagedObjectContext) -> Void {
        
    }
    
    // MARK: Live
    
    /// Generates a set of basic exercises from a data asset as CoreData entries
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateStarterExerciseLibrary(_ context: NSManagedObjectContext) -> Void {
        
        let asset = getAsset("Exercises")
        
        let jsonArray = transformAsset(asset)
        
        for json in jsonArray {
            
            generateExercise(data: json, context)
            
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
        
    public static func generateStarterRoutines(_ context: NSManagedObjectContext) -> Void {
        
    }
        
}
