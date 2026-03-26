//
//  EditThresholdsViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-09.
//

import Foundation
import CoreData
import SwiftUI

class EditThresholdsViewModel: ViewModel {
    
    @Published public var editedLowerBound: String = ""
    
    @Published public var editedUpperBound: String = ""
    
    @Published public var editedFlatLoadAdd: String = ""
    
    @Published public var editedFlatQuantityAdd: String = ""
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var showThresholdChangedAlert: Bool = false
    
    @Published public var addPrSelection: Bool = false
    
    @Published public var prSelection: String = ""
    
    public let addPrSegments: KeyValueList<String, Bool> = KeyValueList([
        ("Add PR", true),
        ("Don't add PR", false)
    ])
    
    public let addRepPrSegments: KeyValueList<String, String> = KeyValueList([
        ("1RM", "onerepmax"),
        ("AMRAP", "maxreps")
    ])
    
    public let addTimePrSegments: KeyValueList<String, String> = KeyValueList([
        ("Time-max", "timemax")
    ])
    
    public func setViewStartValues(entity: SetThreshold) -> Void {
        
        self.editedFlatLoadAdd = String(format: "%.2f", entity.flatLoadAdd?.doubleValue ?? "")
        
        self.addPrSelection = entity.generatePr
                
        let exerciseType = entity.templateSet!.exercise!.exerciseType
        
        if exerciseType == "reps" {
            
            self.prSelection = entity.prType ?? "onerepmax"
            
            self.editedLowerBound = String(format: "%.0f", entity.lowerBound)
            
            self.editedUpperBound = String(format: "%.0f", entity.upperBound)
            
            self.editedFlatQuantityAdd = String(format: "%.0f", entity.flatQuantityAdd?.doubleValue ?? "")
            
        } else if exerciseType == "time" {
            
            self.prSelection = entity.prType ?? "timemax"
            
            self.editedLowerBound = String(format: "%.0f", entity.lowerBound)
            
            self.editedUpperBound = String(format: "%.0f", entity.upperBound)
            
            self.editedFlatQuantityAdd = String(format: "%.2f", entity.flatQuantityAdd?.doubleValue ?? "")
            
        }
    
    }
    
    public func getPlaceHolderUnit(fromExerciseType: String) -> String {
        return fromExerciseType == "reps" ? "reps" : "seconds"
    }
    
    public func getTriggerRangeInputFieldVariant(fromExerciseType: String, min: Double, max: Double) -> InputFieldVariant {
        return fromExerciseType == "reps" ? IntegerIF(min: Int(min), max: Int(max)) : DecimalIF(min: min, max: max)
    }
    
    public func saveEdits(entity: SetThreshold, viewContext: NSManagedObjectContext) -> Void {
        
        let inputFlatLoadAdd: NSNumber? = {
            
            if editedFlatLoadAdd.isEmpty { return nil }
            
            else if Double(editedFlatLoadAdd) == 0 { return nil }
            
            else { return NSNumber(value: Double(editedFlatLoadAdd)!) }
            
        }()
        
        let inputFlatQuantityAdd: NSNumber? = {
            
            if editedFlatQuantityAdd.isEmpty { return nil }
            
            else if Double(editedFlatQuantityAdd) == 0 { return nil }
            
            else { return NSNumber(value: Double(editedFlatQuantityAdd)!) }
            
        }()
        
        if addPrSelection != entity.generatePr {
            
            entity.generatePr = addPrSelection
            
            entity.prType = nil
            
        }
        
        if prSelection != entity.prType && addPrSelection {
            
            entity.prType = prSelection
            
        }
        
        if Double(editedLowerBound) != entity.lowerBound {
            
            entity.lowerBound = Double(editedLowerBound)!
            
        }
        
        if Double(editedUpperBound) != entity.upperBound {
            
            entity.upperBound = Double(editedUpperBound)!
            
        }
        
        if inputFlatLoadAdd != entity.flatLoadAdd {
            
            entity.flatLoadAdd = inputFlatLoadAdd
            
        }
        
        if inputFlatQuantityAdd != entity.flatQuantityAdd {
            
            entity.flatQuantityAdd = inputFlatQuantityAdd
            
        }
        
        if entity.hasChanges {
            
            withAnimation { self.showThresholdChangedAlert = true }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation { self.showNoChangeAlert = true }
            
        }
    }
}
