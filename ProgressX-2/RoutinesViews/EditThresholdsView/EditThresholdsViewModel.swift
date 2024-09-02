//
//  EditThresholdsViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-09.
//

import Foundation
import CoreData
import SwiftUI

class EditThresholdsViewModel: ViewModel, EditingViewModel, DefaultValueViewModel {
    
    @Published public var editedLowerBound: String = ""
    
    @Published public var editedLowerBoundIsInvalid: Bool = false
    
    @Published public var editedLowerBoundIsInvalidMsg: String = ""
    
    @Published public var editedUpperBound: String = ""
    
    @Published public var editedUpperBoundIsInvalid: Bool = false
    
    @Published public var editedUpperBoundIsInvalidMsg: String = ""
    
    @Published public var editedFlatLoadAdd: String = ""
    
    @Published public var editedFlatLoadAddIsInvalid: Bool = false
    
    @Published public var editedFlatLoadAddIsInvalidMsg: String = ""
    
    @Published public var editedFlatQuantityAdd: String = ""
    
    @Published public var editedFlatQuantityAddIsInvalid: Bool = false
    
    @Published public var editedFlatQuantityAddIsInvalidMsg: String = ""
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var showThresholdChangedAlert: Bool = false
    
    @Published public var addPrSelection: Bool = false
    
    @Published public var prSelection: String = ""
    
    public let addPrSegments: [String : Bool] = [
        "Add PR" : true,
        "Don't add PR" : false
    ]
    
    public let addRepPrSegments: [String : String] = [
        "1RM" : "onerepmax",
        "AMRAP" : "maxreps"
    ]
    
    public let addTimePrSegments: [String : String] = [
        "Time-max" : "timemax"
    ]
    
    
    public func setViewStartValues(entity: SetThreshold) -> Void {
        
        editedFlatLoadAdd = String(format: "%.2f", entity.flatLoadAdd?.doubleValue ?? "")
        
        addPrSelection = entity.generatePr
                
        let exerciseType = entity.templateSet!.exercise!.exerciseType
        
        if exerciseType == "reps" {
            
            prSelection = entity.prType ?? "onerepmax"
            
            editedLowerBound = String(format: "%.0f", entity.lowerBound)
            
            editedUpperBound = String(format: "%.0f", entity.upperBound)
            
            editedFlatQuantityAdd = String(format: "%.0f", entity.flatQuantityAdd?.doubleValue ?? "")
            
        } else if exerciseType == "time" {
            
            prSelection = entity.prType ?? "timemax"
            
            editedLowerBound = String(format: "%.0f", entity.lowerBound)
            
            editedUpperBound = String(format: "%.0f", entity.upperBound)
            
            editedFlatQuantityAdd = String(format: "%.2f", entity.flatQuantityAdd?.doubleValue ?? "")
            
        }
    
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
            
            withAnimation { showThresholdChangedAlert = true }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation { showNoChangeAlert = true }
            
        }
    }
}
