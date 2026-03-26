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
        
        self.newName = entity.exerciseName ?? ""
        
        self.newDesc = entity.exerciseDesc ?? ""
        
        for category in entity.categories! {
            
            self.selectedCategories.insert(category as! ExerciseCategory)
        }
        
    }
    
    public func saveEdits(entity: Exercise, viewContext: NSManagedObjectContext) -> Void {
        
        if selectedCategories != Set(_immutableCocoaSet: entity.categories!) {
            for category in entity.categories! {
                entity.removeFromCategories(category as! ExerciseCategory)
            }
            for category in self.selectedCategories {
                entity.addToCategories(category)
            }
        }
        
        if self.newName != entity.exerciseName {
            entity.exerciseName = self.newName
        }
        
        if self.newDesc != entity.exerciseDesc {
            entity.exerciseDesc = self.newDesc
        }
        
        if entity.hasChanges {
            withAnimation {
                self.exerciseEditedAlert = true
            }
            self.save(viewContext)
        } else {
            withAnimation {
                self.noChangeAlert = true
            }
        }
        
    }
}
