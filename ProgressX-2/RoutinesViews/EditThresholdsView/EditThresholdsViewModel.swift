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
    
    @Published public var editedTriggerQuantity: String = ""
    @Published public var editedTriggerQuantityIsInvalid: Bool = false
    @Published public var editedTriggerQuantityIsInvalidMsg: String = ""
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
    
    typealias T = SetThreshold
    
    public func setViewStartValues(entity: SetThreshold) -> Void {
        
        addPrSelection = entity.generatePr
                
        let exerciseType = entity.templateSet!.exercise!.exerciseType
        
        if exerciseType == "reps" {
            prSelection = entity.prType ?? "onerepmax"
            editedTriggerQuantity = String(format: "%.0f", entity.triggerQuantity)
            editedFlatQuantityAdd = String(format: "%.0f", entity.flatQuantityAdd?.doubleValue ?? "")
        } else if exerciseType == "time" {
            prSelection = entity.prType ?? "timemax"
            editedTriggerQuantity = String(format: "%.2f", entity.triggerQuantity)
            editedFlatQuantityAdd = String(format: "%.2f", entity.flatQuantityAdd?.doubleValue ?? "")
        }
        
        editedFlatLoadAdd = String(format: "%.2f", entity.flatLoadAdd?.doubleValue ?? "")
        
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
        
        if Double(editedTriggerQuantity) != entity.triggerQuantity {
            entity.triggerQuantity = Double(editedTriggerQuantity)!
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
