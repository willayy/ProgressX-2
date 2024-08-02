//
//  PopupFeedbackViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//

import Foundation
import CoreData
import SwiftUI

class PopupFeedbackViewModel: ObservableObject {
    
    @Published var selectedExercise: Exercise? = nil
    @Published var selectedSet: TrainingSet? = nil
    
    @Published var editedQuantityType: String = ""
    @Published var editedSetQuantity: String = ""
    @Published var editedSetQuantityIsInvalid: Bool = false
    @Published var editedSetQuantityIsInvalidMsg: String = ""
    
    public func setViewStartValues(selectedTrainigeSet: TrainingSet?) -> Void {
        editedSetQuantity = selectedTrainigeSet!.quantityTodoString!
        print(selectedTrainigeSet!.quantityTodoString)
    }
    
    public func saveSetChanges(viewContext: NSManagedObjectContext, selectedTrainingSet: TrainingSet?) -> Void {
        
        
        if editedSetQuantity == "" {
            selectedTrainingSet?.quantityDone = selectedTrainingSet?.quantityTodo ?? 0.0
        } else {
            selectedTrainingSet?.quantityDone = Double(editedSetQuantity) ?? 0.0
        }
        
        print(selectedTrainingSet!.quantityDone)
        
        if selectedTrainingSet!.hasChanges {
            PersistenceController.save(viewContext)
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
