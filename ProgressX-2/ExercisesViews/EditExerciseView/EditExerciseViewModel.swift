//
//  EditExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import SwiftUI
import CoreData

class EditExerciseViewModel: ViewModel {
    
    // Submission alert variables
    @Published public var exerciseEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    
    // Input variables
    @Published public var newName: String = ""
    @Published public var newDesc: String = ""
    
    // Set variable for categories
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()
    
    typealias T = Exercise
    
    public func setViewStartValues(entity: Exercise) -> Void {
        
        newName = entity.exerciseName ?? ""
        
        newDesc = entity.exerciseDesc ?? ""
        
        for category in entity.categories! {
            
            selectedCategories.insert(category as! ExerciseCategory)
        }
        
    }
    
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
            self.save(viewContext)
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
        
    }
}
