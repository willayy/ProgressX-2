//
//  CreateNewExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewExerciseViewModel: ViewModel {
    
    // Get the viewcontext from the enviorment
    @Environment(\.managedObjectContext) private var viewContext
    
    // Input variables
    @Published public var currBw: Double = 0
    @Published public var enteredExerciseName: String = ""
    @Published public var enteredExerciseDesc: String = ""
    @Published public var enteredPrQuantity: String = ""
    @Published public var enteredPrWeigtLoad: String = ""
    
    // Segment picker choices
    @Published public var selectedTypeOfExercise: String = ExerciseType.Reps.rawValue
    @Published public var selectedTypeOfPr: String = PersonalRecordType.OneRepMax.rawValue
    @Published public var addPr: Bool = false
    
    // Category set
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()
    
    // Segment picker options
    public let exerciseTypeOptions: KeyValueList<String, String> = KeyValueList([
        ("Rep based", ExerciseType.Reps.rawValue),
        ("Time based", ExerciseType.Time.rawValue)
    ])
    
    public let addPrOptions: KeyValueList<String, Bool> = KeyValueList([
        ("Yes",true),
        ("No",false)
    ])
   
    public let timeBasedPrOptions: KeyValueList<String, String> = KeyValueList([
        ("Time-Max", PersonalRecordType.TimeMax.rawValue)
    ])
    
    public let repBasedPrOptions: KeyValueList<String, String> = KeyValueList([
        ("1RM", PersonalRecordType.OneRepMax.rawValue),
        ("AMRAP", PersonalRecordType.MaxReps.rawValue)
    ])
    
    public func prTypeChanged() -> Void {
        
        if selectedTypeOfPr == PersonalRecordType.OneRepMax.rawValue {
            
            // else if "1RM" set to reps 1
            enteredPrQuantity = "1"
            
        } else {
            
            enteredPrQuantity = ""
            
        }
        
    }
    
    public func exerciseTypeChanged() -> Void {
        
        if selectedTypeOfExercise == ExerciseType.Time.rawValue {
            
            // Set the PR selector to the first time based pr option key
            selectedTypeOfPr = timeBasedPrOptions.keys.first!
            
        } else if selectedTypeOfExercise == ExerciseType.Reps.rawValue {
            
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
            type: selectedTypeOfExercise
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
        
        self.save(viewContext)
    }
}
