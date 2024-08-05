//
//  PopupFeedbackViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//

import Foundation
import CoreData
import SwiftUI

class PopupFeedbackViewModel: SavingViewModel, EditingViewModel {
    
    @Published var selectedExercise: Exercise? = nil
    @Published var selectedSet: TrainingSet? = nil
    
    @Published var editedQuantityType: String = ""
    @Published var editedSetQuantity: String = ""
    @Published var editedSetQuantityIsInvalid: Bool = false
    @Published var editedSetQuantityIsInvalidMsg: String = ""
    
    typealias T = TrainingSet
    
    public func setViewStartValues(selectedTrainigeSet: TrainingSet?) -> Void {
        editedSetQuantity = selectedTrainigeSet!.quantityTodoString!
    }
    
    public func saveEdits(entity: TrainingSet, viewContext: NSManagedObjectContext) -> Void {
        
        if Double(editedSetQuantity) == entity.quantityTodo {
            entity.quantityDone = entity.quantityTodo
        } else {
            entity.quantityDone = Double(editedSetQuantity) ?? 0.0
        }
        
        entity.complete()
        
        if entity.hasChanges {
            self.safeSave(viewContext: viewContext)
        }
    }
    // func that returns variable for the quantity placeholder
    public func quantityPlaceholder() -> String {
        switch editedQuantityType {
        case "Numerical":
            let exerciseType = selectedExercise?.exerciseType
            if exerciseType == nil {return "Select exercise first!"}
            return exerciseType == "reps" ? "Reps" : "Seconds"
        case "Percentage of current AMRAP PR":
            return "Percentage"
        case "Percentage of current TimeMax PR":
            return "Percentage"
        default:
            return "Select exercise first!"
        }
    }
    
}
