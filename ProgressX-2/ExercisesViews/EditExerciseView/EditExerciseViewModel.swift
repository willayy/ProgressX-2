//
//  EditExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import SwiftUI
import CoreData

class EditExerciseViewModel: SavingViewModel, EditingViewModel {
    
    // Submission alert variables
    @Published public var exerciseEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    
    // Input variables
    @Published public var newName: String = ""
    @Published public var newDesc: String = ""
    
    // Input error
    @Published public var newNameIsInvalid: Bool = false
    @Published public var newDescIsInvalid: Bool = false
    
    // Input error message
    @Published public var newNameIsInvalidMsg: String = ""
    @Published public var newDescIsInvalidMsg: String = ""
    
    // Set variable for categories
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()

    public func setViewStartValues(selectedExercise: Exercise) -> Void {
        newName = selectedExercise.exerciseName ?? ""
        newDesc = selectedExercise.exerciseDesc ?? ""
    }
    
    typealias T = Exercise
    
    public func saveEdits(entity: Exercise, viewContext: NSManagedObjectContext) -> Void {
        
        if selectedCategories != Set(_immutableCocoaSet: entity.categories!) {
            for category in entity.categories! {
                entity.removeFromCategories(category as! ExerciseCategory)
            }
            for category in selectedCategories {
                entity.addToCategories(category)
            }
        }
        
        if newName != entity.exerciseName {
            entity.exerciseName = newName
        }
        
        if newDesc != entity.exerciseDesc {
            entity.exerciseDesc = newDesc
        }
        
        if entity.hasChanges {
            withAnimation {
                exerciseEditedAlert = true
            }
            self.safeSave(viewContext: viewContext)
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
        
    }
}
