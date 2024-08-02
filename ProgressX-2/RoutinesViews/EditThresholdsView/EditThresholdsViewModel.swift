//
//  EditThresholdsViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-09.
//

import Foundation
import CoreData
import SwiftUI

class EditThresholdsViewModel: SavingViewModel, EditingViewModel, DefaultValueViewModel {
    
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
    public let addPrSegments: [String] = ["Add PR", "Don't add PR"]
    public let addRepPrSegments: [String] = ["1RM", "AMRAP"]
    @Published public var addPrSelection: String = "Don't add PR"
    @Published public var addRepPrSelection: String = "1RM"
    
    typealias T = SetThreshold

    private let addPrMap = [
        "Add PR" : true,
        "Don't add PR" : false
    ]
    
    private let prTypeMap = [
        "1RM" : "onerepmax",
        "AMRAP" : "maxreps",
        "TimeMax" : "timemax"
    ]
    
    private func removeSubstrings(from string: String, substrings: [String]) -> String {
        var modifiedString = string
        for substring in substrings {
            modifiedString = modifiedString.replacingOccurrences(of: substring, with: "")
        }
        return modifiedString
    }
    
    public func setViewStartValues(entity: SetThreshold) -> Void {
        
        let exerciseType: String = entity.templateSet!.exercise!.exerciseType!
        
        let prSelection: String = {
            if entity.generatePr { return "Add PR" }
            else { return "Don't add PR" }
        }()
        
        // Figure the selection of rep based prs if the exercise is rep based.
        // This is not very clean
        let repPrSelection: String = {
            if exerciseType == "reps" {
                if entity.prType == "onerepmax" { return "1RM" }
                else if entity.prType == "maxreps" { return "AMRAP" }
            }
            return "TimeMax"
        }()
        
        // Since the formatted strings from the NSManagedObject subclasses contain suffix we need to strip them away.
        let removeStrings = [" reps", " seconds", " kg's", " lbs"]
        
        addPrSelection = prSelection
        addRepPrSelection = repPrSelection
        editedTriggerQuantity = removeSubstrings(from: entity.triggerQuantityString!, substrings: removeStrings)
        editedFlatLoadAdd = removeSubstrings(from: entity.flatLoadAddString ?? "", substrings: removeStrings)
        editedFlatQuantityAdd = removeSubstrings(from: entity.flatQuantityAddString ?? "", substrings: removeStrings)
        
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
        
        if addPrMap[addPrSelection] != entity.generatePr {
            entity.generatePr = addPrMap[addPrSelection]!
            entity.prType = nil
        }
        
        if prTypeMap[addRepPrSelection] != entity.prType && addPrSelection == "Add PR" {
            entity.prType = prTypeMap[addRepPrSelection]!
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
            self.safeSave(viewContext: viewContext)
        } else {
            withAnimation { showNoChangeAlert = true }
        }
    }
}
