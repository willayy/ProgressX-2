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
    
    // Get the viewcontext from the enviorment
    @Environment(\.managedObjectContext) private var viewContext
    
    // Input variables
    @Published public var currBw: Double = 0
    @Published public var enteredExerciseName: String = ""
    @Published public var enteredExerciseDesc: String = ""
    @Published public var enteredPrQuantity: String = ""
    @Published public var enteredPrWeigtLoad: String = ""
    
    // Segment picker choices
    @Published public var selectedTypeOfExercise: String = "reps"
    @Published public var selectedTypeOfPr: String = "onerepmax"
    @Published public var addPr: Bool = false
    
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
        "Rep based" : "reps",
        "Time based" : "time"
    ]
    
    public let addPrOptions: [String : Bool] = [
        "Yes" : true,
        "No" : false
    ]
   
    public let timeBasedPrOptions: [String : String] = [
        "Time-Max" : "timemax"
    ]
    
    public let repBasedPrOptions: [String : String] = [
        "1RM" : "onerepmax",
        "AMRAP" : "maxreps"
    ]
    
    public func prTypeChanged() -> Void {
        if repBasedPrOptions[selectedTypeOfPr] == "onerepmax" {
            // else if "1RM" set to reps 1
            enteredPrQuantity = "1"
        }
    }
    
    public func exerciseTypeChanged() -> Void {
        if selectedTypeOfExercise == "time" {
            // Set the PR selector to the first time based pr option key
            selectedTypeOfPr = timeBasedPrOptions.keys.first!
        } else if selectedTypeOfExercise == "reps" {
            // Set the PR selector to the first rep based pr option key
            selectedTypeOfPr = repBasedPrOptions.keys.first!
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
        if addPr {
            // Find the pr-type from the user selected value
            
            let _ = PersonalRecord(
                viewContext,
                exercise: exercise,
                weightLoad: Double(enteredPrWeigtLoad)!,
                quantity: Double(enteredPrQuantity)!,
                date: Date(),
                type: selectedTypeOfPr
            )
        }
        
        self.safeSave(viewContext: viewContext)
    }
}
