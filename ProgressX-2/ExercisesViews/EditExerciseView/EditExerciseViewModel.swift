//
//  EditExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import SwiftUI
import CoreData

class EditExerciseViewModel: ObservableObject {
    
    @Published public var exerciseEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    @Published public var newName: String = ""
    @Published public var newDesc: String = ""
    @Published public var newNameIsInvalid: Bool = false
    @Published public var newNameIsInvalidMsg: String = ""
    @Published public var newDescIsInvalid: Bool = false
    @Published public var newDescIsInvalidMsg: String = ""
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()

    public func setViewStartValues(selectedExercise: Exercise?) -> Void {
        newName = selectedExercise!.exerciseName ?? ""
        newDesc = selectedExercise!.exerciseDesc ?? ""
    }
    
    public func saveExerciseChanges(viewContext: NSManagedObjectContext, selectedExercise: Exercise?) -> Void {
        
        if selectedCategories != Set(_immutableCocoaSet: selectedExercise!.categories!) {
            for category in selectedExercise!.categories! {
                selectedExercise!.removeFromCategories(category as! ExerciseCategory)
            }
            for category in selectedCategories {
                selectedExercise!.addToCategories(category)
            }
        }
        
        if newName != selectedExercise!.exerciseName {
            selectedExercise!.exerciseName = newName
        }
        
        if newDesc != selectedExercise!.exerciseDesc {
            selectedExercise!.exerciseDesc = newDesc
        }
        
        if selectedExercise!.hasChanges {            
            withAnimation {
                exerciseEditedAlert = true
                PersistenceController.save(viewContext)
            }
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
        
    }
}
