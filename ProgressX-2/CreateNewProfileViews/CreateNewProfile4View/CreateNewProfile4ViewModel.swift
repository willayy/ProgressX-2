//
//  CreateNewProfile4_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class CreateNewProfile4ViewModel: ViewModel {
    
    // Values for input fields
    @Published var benchPress1RM = ""
    @Published var squat1RM = ""
    @Published var deadLift1RM = ""
    @Published var shoulderPress1RM = ""
    @Published var barbellRow1RM = ""
    @Published var overheadTriExt1RM = ""
    @Published var dumbbellCurl1RM = ""
    @Published var chinupsAmrap = ""
    @Published var pushupsAmrap = ""
    @Published var situpsAmrap = ""
    
    // Constants specific to elements in this view
    let minScaleFactor: Double = 0.05
    let textWidth: Double = 150
    
    public func saveEntry(viewContext: NSManagedObjectContext) {
        
        let latestBodyEntry: BodyEntry = CoreDataAccess.getLatestBodyEntry(viewContext)!
        let bodyWeight: Double = latestBodyEntry.bodyWeight
        
        let personalRecordsFr: NSFetchRequest = PersonalRecord.fetchRequest()
        let personalRecords = CoreDataAccess.fetch(viewContext, fetchRequest: personalRecordsFr)
        
        let exercisesFr: NSFetchRequest = Exercise.fetchRequest()
        let exercises = CoreDataAccess.fetch(viewContext, fetchRequest: exercisesFr)
        
        // Wipe all prs
        for pr in personalRecords {
            CoreDataAccess.delete(viewContext, object: pr)
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
                        type: PersonalRecordType.OneRepMax.rawValue
                    )
                
            case "Squat":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(squat1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: PersonalRecordType.OneRepMax.rawValue
                    )
                
            case "Deadlift":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(deadLift1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: PersonalRecordType.OneRepMax.rawValue
                    )
                
            case "Shoulder press":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: Double(shoulderPress1RM)!,
                        quantity: 1,
                        date: Date(),
                        type: PersonalRecordType.OneRepMax.rawValue
                    )
                
            case "Sit-up":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: bodyWeight,
                        quantity: Double(situpsAmrap)!,
                        date: Date(),
                        type: PersonalRecordType.MaxReps.rawValue
                    )
                
            case "Push-up":
                _ = PersonalRecord(
                        viewContext,
                        exercise: exercise,
                        weightLoad: bodyWeight,
                        quantity: Double(pushupsAmrap)!,
                        date: Date(),
                        type: PersonalRecordType.MaxReps.rawValue
                    )
                
            case "Chin-up":
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: bodyWeight,
                    quantity: Double(chinupsAmrap)!,
                    date: Date(),
                    type: PersonalRecordType.MaxReps.rawValue
                )
                
            case "Leg curl":
                
                // Approximate max from squats.
                let weightLoad = round((Double(squat1RM)! * 0.61))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Leg press":
                
                // Approximate max from squats.
                let weightLoad = round((Double(squat1RM)! * 1.74))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Dumbbell curl":
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: Double(dumbbellCurl1RM)!,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Hammer curl":
                
                // Approximate max from dumbbell curl.
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: Double(dumbbellCurl1RM)!,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Romanian deadlift":
                // Approximate max from deadlift.
                let weightLoad = round((Double(deadLift1RM)! * 0.78))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Overhead tricep extension":
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: Double(overheadTriExt1RM)!,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Lateral raise":
                
                // Approximate max from shoulder press.
                let weightLoad = round((Double(shoulderPress1RM)! * 0.23))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Incline dumbbell press":
                
                // Approximate max from bench press.
                let weightLoad = round((Double(shoulderPress1RM)! * 0.23))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Barbell row":
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: Double(barbellRow1RM)!,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Seated cable row":
                
                // Approximate max from barbell rows
                let weightLoad = round((Double(barbellRow1RM)! * 1))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Tricep pushdown":
                
                // Approximate max from overhead tricep extension
                let weightLoad = round((Double(overheadTriExt1RM)! * 1.1))
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Face pull":
                
                // Approximate max from shoulder press.
                let weightLoad = round(Double(shoulderPress1RM)! * 0.6)
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
            case "Calf raise":
                
                // Approximate max from Squat press.
                let weightLoad = round(Double(squat1RM)! * 0.8)
                
                _ = PersonalRecord(
                    viewContext,
                    exercise: exercise,
                    weightLoad: weightLoad,
                    quantity: 1,
                    date: Date(),
                    type: PersonalRecordType.OneRepMax.rawValue
                )
                
                
            default:
                
                fatalError("An exercise with a name not in the switch statement appearead. This is probably the result of a typo.")
                
            }
        }
    
        self.save(viewContext)
        
    }
    
    public func generateBasicRoutine(viewContext: NSManagedObjectContext) {
        
        if !CoreDataAccess.basicRoutinesExists(viewContext) {
            
            CoreDataAccess.generateStarterRoutines(viewContext)
            
            CoreDataAccess.save(viewContext)
            
        }
    }
    
}
