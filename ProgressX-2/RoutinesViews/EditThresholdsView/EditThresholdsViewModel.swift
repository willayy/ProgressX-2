//
//  EditThresholdsViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-09.
//

import Foundation
import CoreData
import SwiftUI

class EditThresholdsViewModel: ObservableObject {
    
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
    
    public func setViewStartValues(selectedSetThreshold: SetThreshold) -> Void {
        
        let exerciseType: String =  selectedSetThreshold.templateSet!.exercise!.exerciseType!
        
        let prSelection: String = {
            if selectedSetThreshold.generatePr { return "Add PR" }
            else { return "Don't add PR" }
        }()
        
        // Figure the selection of rep based prs if the exercise is rep based.
        // This is not very clean
        let repPrSelection: String = {
            if exerciseType == "reps" {
                if selectedSetThreshold.prType == "onerepmax" { return "1RM" }
                else if selectedSetThreshold.prType == "maxreps" { return "AMRAP" }
            }
            return "TimeMax"
        }()
        
        // Since the formatted strings from the NSManagedObject subclasses contain suffix we need to strip them away.
        let removeStrings = [" reps", " seconds", " kg's", " lbs"]
        
        addPrSelection = prSelection
        addRepPrSelection = repPrSelection
        editedTriggerQuantity = removeSubstrings(from: selectedSetThreshold.triggerQuantityString!, substrings: removeStrings)
        editedFlatLoadAdd = removeSubstrings(from: selectedSetThreshold.flatLoadAddString ?? "", substrings: removeStrings)
        editedFlatQuantityAdd = removeSubstrings(from: selectedSetThreshold.flatQuantityAddString ?? "", substrings: removeStrings)
        
    }
    
    public func saveSetThresholdChanges(context: NSManagedObjectContext, selectedSetThreshold: SetThreshold) -> Void {
        
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
        
        if addPrMap[addPrSelection] != selectedSetThreshold.generatePr {
            selectedSetThreshold.generatePr = addPrMap[addPrSelection]!
            selectedSetThreshold.prType = nil
        }
        
        if prTypeMap[addRepPrSelection] != selectedSetThreshold.prType && addPrSelection == "Add PR" {
            selectedSetThreshold.prType = prTypeMap[addRepPrSelection]!
        }
        
        if Double(editedTriggerQuantity) != selectedSetThreshold.triggerQuantity {
            selectedSetThreshold.triggerQuantity = Double(editedTriggerQuantity)!
        }
        
        if inputFlatLoadAdd != selectedSetThreshold.flatLoadAdd {
            selectedSetThreshold.flatLoadAdd = inputFlatLoadAdd
        }
        
        if inputFlatQuantityAdd != selectedSetThreshold.flatQuantityAdd {
            selectedSetThreshold.flatQuantityAdd = inputFlatQuantityAdd
        }
        
        if selectedSetThreshold.hasChanges {
            withAnimation {
                showThresholdChangedAlert = true
                PersistenceController.save(context)
            }
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
        
    }
    
}
