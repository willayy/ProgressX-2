//
//  PopupFeedbackViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//

import Foundation
import CoreData
import SwiftUI

class PopupFeedbackViewModel: SavingViewModel, EditingViewModel, DefaultValueViewModel {
    
    @Published var text = ""
    @Published var showWindow: Bool = false
    @Published var editedSetQuantity: String = ""
    @Published var editedSetQuantityIsInvalid: Bool = false
    @Published var editedSetQuantityIsInvalidMsg: String = ""
    
    typealias T = TrainingSet
    
    public func setViewStartValues(entity: TrainingSet) -> Void {
        editedSetQuantity = String(format: "%.0f", entity.quantityTodo)
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
        
    public func saveEdits(entity: TrainingSet, viewContext: NSManagedObjectContext) -> Void {
        
        if Double(editedSetQuantity) == entity.quantityTodo {
            entity.quantityDone = entity.quantityTodo
        } else {
            entity.quantityDone = Double(editedSetQuantity) ?? 0.0
        }
        
        if entity.hasChanges {
            self.safeSave(viewContext: viewContext)
        }
    }
    
    public func changeText(text: String) {
        self.text = text
    }
    
}
