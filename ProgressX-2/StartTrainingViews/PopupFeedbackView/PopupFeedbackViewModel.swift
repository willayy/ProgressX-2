//
//  PopupFeedbackViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//

import Foundation
import CoreData
import SwiftUI

class PopupFeedbackViewModel: ViewModel {

    @Published var showDidntFinishAllReps = false
    
    @Published var editedSetQuantity: String = ""
    
    public func setViewStartValues(entity: TrainingSet) -> Void {
        editedSetQuantity = String(format: "%.0f", entity.quantityTodo)
    }
    
    public func getPopupWindowTitle(exercise: Exercise) -> String {
        if exercise.exerciseType! == "reps" {
            return "Did you complete all your reps"
        } else if exercise.exerciseType! == "time" {
            return "Did you complete the full training time"
        } else {
            return ""
        }
    }
    
    public func getDidntFinishSetTitle(exercise: Exercise) -> String {
        if exercise.exerciseType! == "reps" {
            return "How many reps did you do?"
        } else if exercise.exerciseType! == "time" {
            return "How many seconds did you manage to do?"
        } else {
            return ""
        }
    }
    
    public func setFullyCompleted(currentTrainingSet: TrainingSet) -> Void {
        currentTrainingSet.loadDone = currentTrainingSet.loadTodo
        currentTrainingSet.quantityDone = currentTrainingSet.quantityTodo
        currentTrainingSet.complete()
    }
    
    public func setPartiallyCompleted(currentTrainingSet: TrainingSet, quantityDone: Double) -> Void {
        currentTrainingSet.quantityDone = quantityDone
        currentTrainingSet.loadDone = currentTrainingSet.loadTodo
        currentTrainingSet.complete()
    }
    
    public func checkIfCycleIsFinished(routine: Routine, viewContext: NSManagedObjectContext) -> Void {
        // If the training cycle is finished create a new one.
        if !routine.incompleteTrainingCycleExists {
            CoreDataAccess.createNewCycleFromRoutine(
                routine: routine,
                context: viewContext
            )
        }
    }
        
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        self.save(viewContext)
    }

}
