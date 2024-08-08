//
//  EditPrViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class EditPrViewModel: ViewModel, EditingViewModel, DefaultValueViewModel {
    
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
    
    typealias T = PersonalRecord
    
    public func setViewStartValues(entity: PersonalRecord) -> Void {
        editedDate = entity.achievedOnDate!
        editedWeightLoad = String(format: "%.2f", entity.weightLoad)
        editedQuantity = String(Int(entity.prQuantity))
    }
    
    public func saveEdits(entity: PersonalRecord, viewContext: NSManagedObjectContext) -> Void {
        
        if entity.weightLoad != Double(editedWeightLoad) {
            entity.weightLoad = Double(editedWeightLoad)!
        }
            
        if entity.prQuantity != Double(editedQuantity) {
            entity.prQuantity = Double(editedQuantity)!
        }
            
        if entity.achievedOnDate != editedDate {
            entity.achievedOnDate = editedDate
        }
        
        if entity.hasChanges {
            withAnimation {
                prEditedAlert = true
            }
            self.save(viewContext)
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
    }
    
}
