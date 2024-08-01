//
//  PersistenceGen.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData
import UIKit

extension PersistenceController {
    
    /// Generates a set of basic exercises from a data asset as CoreData entries
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateBasicExerciseLibrary(_ context: NSManagedObjectContext) -> Void {
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        let jsonArray = try! JSONSerialization.jsonObject(
            with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments
        ) as! [[String: Any]]
        
        for json in jsonArray {
            let name = json["name"]! as! String
            let description = json["description"]! as! String
            let type = json["type"]! as! String
            let categories: [String] = json["categories"]! as! [String]
            
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
    }
    
    /// Generates a set of exerciseCategories from a data asset as CoreData entries.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateBasicExerciseCategories(_ context: NSManagedObjectContext) -> Void {
        guard let asset = NSDataAsset(name: "ExerciseCategories", bundle: Bundle.main) else {
            fatalError("Could not find Exercise categories")
        }
        
        let jsonArray = try! JSONSerialization.jsonObject(
            with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments
        ) as! [String]
        
        for exerciseCategoryName in jsonArray {
            _ = ExerciseCategory(
                context,
                name: exerciseCategoryName
            )
        }
    }
    
    /// Generates a basic routine.
    /// - Parameter context: NSManagedObjectContext
    /// - Returns: Void
    public static func generateBasicRoutine(_ context: NSManagedObjectContext) -> Void {
        
        let squat = getExercise(context, name: "Squat")!
        let benchPress = getExercise(context, name: "Bench press")!
        let shoulderPress = getExercise(context, name: "Shoulder press")!
        let deadlift = getExercise(context, name: "Deadlift")!
        let bicepCurls = getExercise(context, name: "Bicep curls")!
        let tricepPushDown = getExercise(context, name: "Tricep pushdown")!
        let sitUp = getExercise(context, name: "Sit up")!
        let profile = getProfile(context)!
        let latestBw = getLatestBodyEntry(context)!.bodyWeight
        
        let routine = Routine(
            context,
            name: "Example routine",
            description: "An example routine to showcase how ProgressX works, not meant to be used in it's current state."
        )
        
        let templateCycle = TemplateCycle(
            context,
            routine: routine
        )
        
            // Week 1
            let templateWeek1 = TemplateWeek(
                context,
                templateCycle: templateCycle,
                name: "Regular week"
            )
        
                // Session 1 Week 1
                let templateSession11 = TemplateSession(
                    context,
                    templateWeek: templateWeek1,
                    name: "Upper body day"
                )
                    
                    // Set 1 Session 1 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession11,
                        name: "Bench press",
                        exercise: benchPress,
                        loadType: "maxperc",
                        load: 75,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
                    
                    // Set 2 Session 1 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession11,
                        name: "Shoulder press",
                        exercise: shoulderPress,
                        loadType: "maxperc",
                        load: 75,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
                    
                    // Set 3 Session 1 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession11,
                        name: "Bicep curls",
                        exercise: bicepCurls,
                        loadType: "numerical",
                        load: 7.5,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                    // Set 4 Session 1 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession11,
                        name: "Tricep pushdowns",
                        exercise: tricepPushDown,
                        loadType: "numerical",
                        load: 7.5,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                // Session 2 Week 1
                let templateSession12 = TemplateSession(
                    context,
                    templateWeek: templateWeek1,
                    name: "Lower body day"
                )
                    
                    // Set 1 Session 2 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession12,
                        name: "Squats",
                        exercise: squat,
                        loadType: "maxperc",
                        load: 75,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                    // Set 2 Session 2 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession12,
                        name: "Deadlifts",
                        exercise: deadlift,
                        loadType: "maxperc",
                        load: 75,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                    // Set 3 Session 2 Week 1
                    _ = TemplateSet(
                        context,
                        templateSession: templateSession12,
                        exercise: sitUp,
                        loadType: "numerical",
                        load: latestBw,
                        quantityType: "numerical",
                        quantity: 20,
                        restTime: profile.standardRestTime
                    )
                
            // Week 2
            let templateWeek2 = TemplateWeek(
                context,
                templateCycle: templateCycle,
                name: "PR week"
            )
        
                // Session 1 Week 2
                let templateSession21 = TemplateSession(
                    context,
                    templateWeek: templateWeek2,
                    name: "Upper body day (PR)"
                )
                    
                    // Set 1 Session 1 Week 2
                    let templateSet211 = TemplateSet(
                        context,
                        templateSession: templateSession21,
                        name: "Bench press",
                        exercise: benchPress,
                        loadType: "maxperc",
                        load: 110,
                        quantityType: "numerical",
                        quantity: 1,
                        restTime: profile.standardRestTime
                    )
                    
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet211,
                            triggeredAt: 1,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: nil,
                            flatQuantityAdd: nil
                        )

                    // Set 2 Session 1 Week 2
                    let templateSet212 = TemplateSet(
                        context,
                        templateSession: templateSession21,
                        name: "Shoulder press",
                        exercise: shoulderPress,
                        loadType: "maxperc",
                        load: 110,
                        quantityType: "numerical",
                        quantity: 1,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet212,
                            triggeredAt: 1,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: nil,
                            flatQuantityAdd: nil
                        )
                    
                    // Set 3 Session 1 Week 2
                    let templateSet213 = TemplateSet(
                        context,
                        templateSession: templateSession21,
                        name: "Bicep curls",
                        exercise: bicepCurls,
                        loadType: "numerical",
                        load: 7.5,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet213,
                            triggeredAt: 10,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: 2.5,
                            flatQuantityAdd: nil
                        )

                    // Set 4 Session 1 Week 2
                    let templateSet214 = TemplateSet(
                        context,
                        templateSession: templateSession21,
                        name: "Tricep pushdowns",
                        exercise: tricepPushDown,
                        loadType: "numerical",
                        load: 7.5,
                        quantityType: "numerical",
                        quantity: 10,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet214,
                            triggeredAt: 10,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: 2.5,
                            flatQuantityAdd: nil
                        )
        
                // Session 2 Week 2
                let templateSession22 = TemplateSession(
                    context,
                    templateWeek: templateWeek2,
                    name: "Lower body day"
                )

                    // Set 1 Session 2 Week 2
                    let templateSet221 = TemplateSet(
                        context,
                        templateSession: templateSession22,
                        name: "Squats",
                        exercise: squat,
                        loadType: "maxperc",
                        load: 110,
                        quantityType: "numerical",
                        quantity: 1,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet221,
                            triggeredAt: 1,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: nil,
                            flatQuantityAdd: nil
                        )

                    // Set 2 Session 2 Week 2
                    let templateSet222 = TemplateSet(
                        context,
                        templateSession: templateSession22,
                        name: "Deadlifts",
                        exercise: deadlift,
                        loadType: "maxperc",
                        load: 110,
                        quantityType: "numerical",
                        quantity: 1,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet222,
                            triggeredAt: 1,
                            generatesPr: true,
                            prType: "onerepmax",
                            flatLoadAdd: nil,
                            flatQuantityAdd: nil
                        )
                    
                    // Set 2 Session 2 Week 2
                    let templateSet223 = TemplateSet(
                        context,
                        templateSession: templateSession22,
                        name: "Sit ups",
                        exercise: sitUp,
                        loadType: "numerical",
                        load: latestBw,
                        quantityType: "numerical",
                        quantity: 20,
                        restTime: profile.standardRestTime
                    )
        
                        _ = SetThreshold(
                            context,
                            templateSet: templateSet223,
                            triggeredAt: 20,
                            generatesPr: true,
                            prType: "maxreps",
                            flatLoadAdd: nil,
                            flatQuantityAdd: 2
                        )
    }
    
}
