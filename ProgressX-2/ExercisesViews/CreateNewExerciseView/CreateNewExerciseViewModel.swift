//
//  CreateNewExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewExerciseViewModel: SavingViewModel, AddingViewModel {
    
    // Input variables
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
    
    // Invalid input error
    @Published public var enteredExerciseNameIsInvalid: Bool = false
    @Published public var enteredExerciseDescIsInvalid: Bool = false
    @Published public var enteredPrQuantityIsInvalid: Bool = false
    @Published public var enteredPrWeigtLoadIsInvalid: Bool = false
    
    // Invalid input messages
    @Published public var enteredExerciseNameIsInvalidMsg: String = ""
    @Published public var enteredExerciseDescIsInvalidMsg: String = ""
    @Published public var enteredPrQuantityIsInvalidMsg: String = ""
    @Published public var enteredPrWeigtLoadIsInvalidMsg: String = ""
    
    // Category set
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()
    
    // Segment picker options
    public let exerciseTypeOptions: [String : String] = [
        "Reps" : "reps",
        "Time" : "time"
    ]
    
    public let addPrOptions: [String : Bool] = [
        "Yes" : true,
        "No" : false
    ]
   
    public let timeBasedPrOptions: [String : String] = [
        "Time-Max" : "timemax"
    ]
    
    public let repBasedPrOptions: [String : String] = [
        "AMRAP" : "maxreps",
        "1RM" : "onerepmax"
    ]
    
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
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        // Create the new exercise
        
        let exercise = Exercise(
            viewContext,
            name: enteredExerciseName,
            description: enteredExerciseDesc,
            type: exerciseTypeOptions[selectedTypeOfExercise]!
        )
        
        for category in selectedCategories {
            category.addToExercise(exercise)
            exercise.addToCategories(category)
        }
        
        // Add pr if selected
        if addPr == "Yes" {
            // Find the pr-type from the user selected value
            let prType: String
            
            if selectedTypeOfExercise == "Reps" {
                #warning("Continue here")
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
        
        self.safeSave(viewContext: viewContext)
        
        // Reset the selected values
        withAnimation(.easeOut) {
            enteredExerciseName = ""
            enteredExerciseDesc = ""
            selectedTypeOfExercise = "Reps"
            selectedTypeOfPr = "1RM"
            addPr = "No"
        }
    }
    
}
