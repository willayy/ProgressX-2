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
    @Published var text = ""
    @Published var showWindow: Bool = false
    @Published var editedQuantityType: String = ""
    @Published var editedSetQuantity: String = ""
    @Published var editedSetQuantityIsInvalid: Bool = false
    @Published var editedSetQuantityIsInvalidMsg: String = ""
    
    typealias T = TrainingSet
    
    public func setViewStartValues(selectedTrainigeSet: TrainingSet?) -> Void {
        editedSetQuantity = String(format: "%.0f", selectedTrainigeSet!.quantityTodo)
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
    
    public func changeText(text: String) {
        self.text = text
    }
    
}
