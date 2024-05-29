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
        
        //MARK: The preview database for the application
        
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
        
        // Initialise a database with test values for the preview
        
        let profile: Profile = Profile(context: previewContainer.viewContext)
            .setValue_ch("TestProfile", forKey: "userName")
            .setValue_ch("male", forKey: "gender")
            .setValue_ch(true, forKey: "isMetric")
            .setValue_ch(Date(), forKey: "birthDay")
            .setValue_ch(187, forKey: "height")
            
        let bw1 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(100, forKey: "bodyWeight")
            .setValue_ch(Date()-2, forKey: "date")
            bw1.profile = profile
        
        let bw2 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(95, forKey: "bodyWeight")
            .setValue_ch(Date()-1, forKey: "date")
            bw2.profile = profile
        
        let bw3 = BodyEntry(context: previewContainer.viewContext)
            .setValue_ch(97, forKey: "bodyWeight")
            .setValue_ch(Date(), forKey: "date")
            bw3.profile = profile
        
        profile.addToBodyEntries(bw1)
        profile.addToBodyEntries(bw2)
        profile.addToBodyEntries(bw3)
        
        let testExercise = RepBasedExercise(context: previewContainer.viewContext)
            .setValue_ch("testing exercise", forKey: "exerciseName")
            .setValue_ch("This exercise is used for debugging purposes within the canvas preview", forKey: "exerciseDesc")
        
        let pr1 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(75, forKey: "load")
            .setValue_ch(Date()-2, forKey: "achievedOnDate")
            pr1.repBasedExercise = testExercise
        
        let pr2 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(80, forKey: "load")
            .setValue_ch(Date()-1, forKey: "achievedOnDate")
            pr2.repBasedExercise = testExercise
        
        let pr3 = OneRepMax(context: previewContainer.viewContext)
            .setValue_ch(77, forKey: "load")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            pr3.repBasedExercise = testExercise
        
        testExercise.addToOneRepMaxPrs(pr1)
        testExercise.addToOneRepMaxPrs(pr2)
        testExercise.addToOneRepMaxPrs(pr3)
        
        do {
            try previewContainer.viewContext.save()
        } catch let error as NSError {
            fatalError("Failed to save context: \(error), \(error.userInfo)")
        }
        
        
    }
}


