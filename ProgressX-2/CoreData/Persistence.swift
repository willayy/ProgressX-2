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
    
    let previewContainer: NSPersistentContainer

    init() {
        
        //MARK: The live database for the application
        
        container = NSPersistentContainer(name: "ProgressX_2")
                
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        //MARK: The preview / test database for the application
        
        previewContainer = NSPersistentContainer(name: "ProgressX_2")
        
        previewContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        
        previewContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        previewContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        //MARK: Initialise a in-memory database with test values for the preview
        
        let profile: Profile = Profile(context: previewContainer.viewContext)
            .setValue_ch("TestProfile", forKey: "userName")
            .setValue_ch("male", forKey: "gender")
            .setValue_ch(true, forKey: "isMetric")
            .setValue_ch(Date(), forKey: "birthDay")
            .setValue_ch(187, forKey: "height")
            
        let bw1 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(100, forKey: "bodyWeight")
            .setValue_ch(Date()-20000, forKey: "date")
            bw1.profile = profile
        
        let bw2 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(95, forKey: "bodyWeight")
            .setValue_ch(Date()-10000, forKey: "date")
            bw2.profile = profile
        
        let bw3 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(97, forKey: "bodyWeight")
            .setValue_ch(Date(), forKey: "date")
            bw3.profile = profile
        
        profile.addToBodyEntries(bw1)
        profile.addToBodyEntries(bw2)
        profile.addToBodyEntries(bw3)
        
        let testExercise1 = RepBasedExercise(context: previewContainer.viewContext)
            .setValue_ch("testing exercise (reps)", forKey: "exerciseName")
            .setValue_ch("This exercise is used for debugging purposes within the canvas preview", forKey: "exerciseDesc")
        
        let testExercise2 = TimeBasedExercise(context: previewContainer.viewContext)
            .setValue_ch("testing exercise (time)", forKey: "exerciseName")
            .setValue_ch("This exercise is used for debugging purposes within the canvas preview", forKey: "exerciseDesc")
        
        let ORMpr1 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(75, forKey: "load")
            .setValue_ch(Date()-20000, forKey: "achievedOnDate")
            ORMpr1.repBasedExercise = testExercise1
        
        let ORMpr2 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(80, forKey: "load")
            .setValue_ch(Date()-10000, forKey: "achievedOnDate")
            ORMpr2.repBasedExercise = testExercise1
        
        let ORMpr3 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(77, forKey: "load")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            ORMpr3.repBasedExercise = testExercise1
        
        let MRpr1 = MaxReps(context: previewContainer.viewContext)
            .setValue_ch(100, forKey: "load")
            .setValue_ch(10, forKey: "reps")
            .setValue_ch(Date()-20000, forKey: "achievedOnDate")
            MRpr1.repBasedExercise = testExercise1
        
        let MRpr2 = MaxReps(context: previewContainer.viewContext)
            .setValue_ch(95, forKey: "load")
            .setValue_ch(12, forKey: "reps")
            .setValue_ch(Date()-10000, forKey: "achievedOnDate")
            MRpr2.repBasedExercise = testExercise1
        
        let MRpr3 = MaxReps(context: previewContainer.viewContext)
            .setValue_ch(97, forKey: "load")
            .setValue_ch(16, forKey: "reps")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            MRpr3.repBasedExercise = testExercise1
        
        let TIMpr1 = TimeMax(context: previewContainer.viewContext)
            .setValue_ch(40.1, forKey: "time")
            .setValue_ch(100, forKey: "load")
            .setValue_ch(Date()-20000, forKey: "achievedOnDate")
            TIMpr1.timeBasedExercise = testExercise2
        
        let TIMpr2 = TimeMax(context: previewContainer.viewContext)
            .setValue_ch(45.6, forKey: "time")
            .setValue_ch(95, forKey: "load")
            .setValue_ch(Date()-10000, forKey: "achievedOnDate")
            TIMpr2.timeBasedExercise = testExercise2
        
        let TIMpr3 = TimeMax(context: previewContainer.viewContext)
            .setValue_ch(70.8, forKey: "time")
            .setValue_ch(97, forKey: "load")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            TIMpr3.timeBasedExercise = testExercise2
        
        testExercise1.addToOneRepMaxPrs(ORMpr1)
        testExercise1.addToOneRepMaxPrs(ORMpr2)
        testExercise1.addToOneRepMaxPrs(ORMpr3)
        testExercise1.addToMaxRepPrs(MRpr1)
        testExercise1.addToMaxRepPrs(MRpr2)
        testExercise1.addToMaxRepPrs(MRpr3)
        testExercise2.addToTimePrs(TIMpr1)
        testExercise2.addToTimePrs(TIMpr2)
        testExercise2.addToTimePrs(TIMpr3)
        
        do {
            try previewContainer.viewContext.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error), \(error.userInfo)")
        }
        
        
    }
}


