//
//  CreateNewExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewExerciseViewModel: ObservableObject {
    
    @Published public var currBw: Double = 0
    @Published public var enteredExerciseName: String = ""
    @Published public var enteredExerciseDesc: String = ""
    @Published public var enteredPrQuantity: String = ""
    @Published public var enteredPrWeigtLoad: String = ""
    // Segment picker choices
    @Published public var selectedTypeOfExercise: String = "Reps"
    @Published public var selectedTypeOfPr: String = "1RM"
    @Published public var addPr: String = "No"
    @Published public var achieviedOnCurrBw: String = "Yes"
    // Pop-up alert
    @Published public var exerciseCreatedAlert: Bool = false
    // Input field vars
    @Published public var enteredExerciseNameIsInvalid: Bool = false
    @Published public var enteredExerciseDescIsInvalid: Bool = false
    @Published public var enteredPrQuantityIsInvalid: Bool = false
    @Published public var enteredPrWeigtLoadIsInvalid: Bool = false
    @Published public var enteredExerciseNameIsInvalidMsg: String = ""
    @Published public var enteredExerciseDescIsInvalidMsg: String = ""
    @Published public var enteredPrQuantityIsInvalidMsg: String = ""
    @Published public var enteredPrWeigtLoadIsInvalidMsg: String = ""
    // Segment picker options
    public let exerciseTypeOptions: [String] = ["Reps", "Time"]
    public let addPrOptions: [String] = ["Yes", "No"]
    public let achievedAtBwOptions: [String] = ["Yes", "No"]
    public let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    public func prTypeChanged(bodyEntries: FetchedResults<BodyEntry>) -> Void {
        if selectedTypeOfPr == "AMRAP" {
            // set default load to bodyweight
            enteredPrWeigtLoad = String(bodyEntries.first!.bodyWeight)
            enteredPrQuantity = ""
        } else if selectedTypeOfPr == "1RM" {
            // else if "1RM" set to reps 1 and load to nothing
            enteredPrQuantity = "1"
            enteredPrWeigtLoad = ""
        }
    }
    
    public func exerciseTypeChanged(bodyEntries: FetchedResults<BodyEntry>) -> Void {
        if selectedTypeOfExercise == "Time" {
            // Set the PR selector and set default load to bodyweight
            selectedTypeOfPr = "Time-max"
            enteredPrQuantity = ""
            enteredPrWeigtLoad = String(bodyEntries.first!.bodyWeight)
        } else {
            // else set no default
            enteredPrWeigtLoad = ""
        }
    }
    
    public func createNewExercise(viewContext: NSManagedObjectContext) -> Void {
        // Create the new exercise
        
        let exercise = Exercise(
            viewContext,
            name: enteredExerciseName,
            description: enteredExerciseDesc,
            type: (selectedTypeOfExercise == "Reps") ? "reps" : "time"
        )
        
        // Add pr if selected
        if addPr == "Yes" {
            // Find the pr-type from the user selected value
            let prType: String
            
            switch selectedTypeOfPr {
                case "AMRAP":
                    prType = "maxreps"
                case "1RM":
                    prType = "onerepmax"
                case "Time-max":
                    prType = "timemax"
                default:
                    prType = "" // This should never be the case
            }
            
            let pr = PersonalRecord(
                viewContext,
                exercise: exercise,
                weightLoad: Double(enteredPrWeigtLoad)!,
                quantity: Double(enteredPrQuantity)!,
                date: Date(),
                type: prType
            )
            
            exercise.addToPersonalRecords(pr)
        }
        
        PersistenceController.save(viewContext)
        
        // Reset the selected values
        withAnimation(.easeOut) {
            enteredExerciseName = ""
            enteredExerciseDesc = ""
            selectedTypeOfExercise = "Reps"
            selectedTypeOfPr = "1RM"
            addPr = "No"
            exerciseCreatedAlert = true
        }
    }
    
}
