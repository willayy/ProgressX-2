//
//  CreateNewProfile4_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class CreateNewProfile4ViewModel: ObservableObject {
    
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
    
    // Constants specific to elements in this view
    let inputFieldWidth: Double = 0.2
    let minScaleFactor: Double = 0.05
    let textWidth: Double = 150
    
    public func addExtraInfo(viewContext: NSManagedObjectContext, bodyEntries: FetchedResults<BodyEntry>, exercises: FetchedResults<Exercise>, personalRecords: FetchedResults<PersonalRecord>) {
        
        let bodyWeight: Double = bodyEntries.first!.bodyWeight
        
        // Wipe all prs
        for pr in personalRecords {
            PersistenceController.delete(viewContext, object: pr)
        }
        
        PersistenceController.save(viewContext)
        
        // Iterate through basic exercises generated and map the correct values to the correct exercise. Very boilerplaty code, should probably be replaced by something more sophisticated.
        for exercise in exercises {
            
            switch exercise.exerciseName {
            case "Bench-press":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(benchPress1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Squat":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(squat1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Deadlift":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(deadLift1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Shoulder-press":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(shoulderPress1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Sit-up":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: bodyWeight,
                        q: Double(situpsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            case "Push-up":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: bodyWeight,
                        q: Double(pushupsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            default:
                continue
            }
        }
        PersistenceController.save(viewContext)
    }
    
}
