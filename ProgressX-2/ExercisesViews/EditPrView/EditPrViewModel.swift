//
//  EditPrViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class EditPrViewModel: SavingViewModel {
    
    // Input field vars
    @Published public var editedDate: Date = Date()
    @Published public var editedQuantity: String = ""
    @Published public var editedWeightLoad: String = ""
    @Published public var editedQuantityInvalid: Bool = false
    @Published public var editedWeightLoadInvalid: Bool = false
    @Published public var editedQuantityInvalidMsg: String = ""
    @Published public var editedWeightLoadInvalidMsg: String = ""
    // Alert vars
    @Published public var prEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    
    public func setViewStartValues(editingPr: PersonalRecord) -> Void {
        editedDate = editingPr.achievedOnDate!
        editedWeightLoad = String(format: "%.2f", editingPr.weightLoad)
        editedQuantity = String(Int(editingPr.prQuantity))
    }
    
    public func savePersonalRecordChanges(viewContext: NSManagedObjectContext, editingPr: PersonalRecord) -> Void {
        
        if editingPr.weightLoad != Double(editedWeightLoad) {
            editingPr.weightLoad = Double(editedWeightLoad)!
        }
            
        if editingPr.prQuantity != Double(editedQuantity) {
            editingPr.prQuantity = Double(editedQuantity)!
        }
            
        if editingPr.achievedOnDate != editedDate {
            editingPr.achievedOnDate = editedDate
        }
        
        if editingPr.hasChanges {
            withAnimation {
                prEditedAlert = true
            }
            self.safeSave(viewContext: viewContext)
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
    }
    
}
