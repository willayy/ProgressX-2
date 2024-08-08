//
//  CreateNewProfile4_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class CreateNewProfile4ViewModel: ViewModel, AddingViewModel {
    
    // Values for input fields
    @Published var benchPress1RM = ""
    @Published var squat1RM = ""
    @Published var deadLift1RM = ""
    @Published var shoulderPress1RM = ""
    @Published var pushupsAmrap = ""
    @Published var situpsAmrap = ""

    // Valid states for inputfields
    @Published var benchPress1RMIsInvalid = false
    @Published var squat1RMIsInvalid = false
    @Published var deadLift1RMIsInvalid = false
    @Published var shoulderPress1RMIsInvalid = false
    @Published var situpsAmrapIsInvalid = false
    @Published var pushupsAmrapIsInvalid = false

    // Error messages for inputfields
    @Published var benchPress1RMIsInvalidMsg = ""
    @Published var squat1RMIsInvalidMsg = ""
    @Published var deadLift1RMIsInvalidMsg = ""
    @Published var shoulderPress1RMIsInvalidMsg = ""
    @Published var situpsAmrapIsInvalidMsg = ""
    @Published var pushupsAmrapIsInvalidMsg = ""
    
    // Variables for saveEntry
    @Published public var bodyWeight: Double? = nil
    
    // Constants specific to elements in this view
    let minScaleFactor: Double = 0.05
    let textWidth: Double = 150
    
    public func saveEntry(viewContext: NSManagedObjectContext) {
        
        let personalRecordsFr: NSFetchRequest = PersonalRecord.fetchRequest()
        let personalRecords = PersistenceController.fetch(viewContext, fetchRequest: personalRecordsFr)
        
        let exercisesFr: NSFetchRequest = Exercise.fetchRequest()
        let exercises = PersistenceController.fetch(viewContext, fetchRequest: exercisesFr)
        
        // Wipe all prs
        for pr in personalRecords {
            PersistenceController.delete(viewContext, object: pr)
        }
        
        // Iterate through basic exercises generated and map the correct values to the correct exercise. Very boilerplaty code, should probably be replaced by something more sophisticated.
        for exercise in exercises {
            
            switch exercise.exerciseName {
            case "Bench press":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(benchPress1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Squat":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(squat1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Deadlift":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(deadLift1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Shoulder press":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(shoulderPress1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Sit up":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: bodyWeight!,
                        quantity: Double(situpsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            case "Push up":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: bodyWeight!,
                        quantity: Double(pushupsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            default:
                continue
            }
        }
    
        self.save(viewContext)
        
    }
    
    public func generateBasicRoutine(viewContext: NSManagedObjectContext) {
        if !PersistenceController.basicRoutineExists(viewContext) {
            PersistenceController.generateBasicRoutine(viewContext)
            PersistenceController.save(viewContext)
        }
    }
    
}
