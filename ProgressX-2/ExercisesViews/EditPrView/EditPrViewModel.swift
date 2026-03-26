//
//  EditPrViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class EditPrViewModel: ViewModel {
    
    // Input field vars
    @Published public var editedDate: Date = Date()
    
    @Published public var editedQuantity: String = ""
    
    @Published public var editedWeightLoad: String = ""
    
    // Alert vars
    @Published public var prEditedAlert: Bool = false
    
    @Published public var noChangeAlert: Bool = false
        
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
    
    /// Gets the correct variant depending on what type the personal record is.
    public func getInputFieldVariant(fromPrType: String) -> InputFieldVariant {
        
        // Check which type the PR should be
        if fromPrType == PersonalRecordType.MaxReps.rawValue {
            
            return IntegerIF(min: 0, max: 100000)
            
            
        }
        
        else if fromPrType == PersonalRecordType.TimeMax.rawValue {
            
            return DecimalIF(min: 0, max: 100000)

        }
        
        // Catch statement that will never occur but is needed for the static type checker
        fatalError("local view variable prType should be timemax or maxreps but was: \(fromPrType)")
        
    }
    
    /// Gets the correct placeholder depending on what type the personal record is.
    public func getInputFieldPlaceholder(fromPrType: String) -> String {
        
        // Check which type the PlaceHolder should be
        if fromPrType == PersonalRecordType.MaxReps.rawValue {
            
            return "Reps"
            
        }
        
        else if fromPrType == PersonalRecordType.TimeMax.rawValue {
            
            return "Seconds"

        }
        
        // Catch statement that will never occur but is needed for the static type checker
        fatalError("local view variable prType should be timemax or maxreps but was: \(fromPrType)")
        
    }
    
}
