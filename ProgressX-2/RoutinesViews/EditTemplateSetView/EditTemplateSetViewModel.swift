//
//  EditTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-07.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSetViewModel: ViewModel, EditingViewModel, DefaultValueViewModel {
    
    // The Name of the set (good default is provided)
    @Published var editedSetName: String = ""
    @Published var editedSetNameIsInvalid: Bool = false
    @Published var editedSetNameIsInvalidMsg: String = ""
    // The Description of the set (Optional)
    @Published var editedSetDesc: String = ""
    @Published var editedSetDescIsInvalid: Bool = false
    @Published var editedSetDescIsInvalidMsg: String = ""
    // The Load of the set
    @Published var editedSetLoad: String = ""
    @Published var editedSetLoadIsInvalid: Bool = false
    @Published var editedSetLoadIsInvalidMsg: String = ""
    // The Quantity of the set
    @Published var editedSetQuantity: String = ""
    @Published var editedSetQuantityIsInvalid: Bool = false
    @Published var editedSetQuantityIsInvalidMsg: String = ""
    // The rest time of the set
    @Published var editedRestTime: String = ""
    @Published var editedRestTimeIsInvalid: Bool = false
    @Published var editedRestTimeIsInvalidMsg: String = ""
    // The PositionIndex of the set
    @Published var editedSetPositionIndex: Int64 = 0
    // The load type of the set
    @Published var editedLoadType: String = ""
    // The quantity type of the set
    @Published var editedQuantityType: String = ""
    // Edit the exercise of the set
    @Published var searchWord: String = ""
    @Published var selectedExercise: Exercise? = nil
    // Change alert states
    @Published var showNoChangeAlert: Bool = false
    @Published var showSetChangedAlert: Bool = false
    
    typealias T = TemplateSet
    
    public func setViewStartValues(entity: TemplateSet) -> Void {
        editedSetName = entity.timePeriodName!
        editedSetDesc = entity.timePeriodDescription!
        editedSetPositionIndex = entity.positionIndex
        selectedExercise = entity.exercise!
        editedLoadType = loadTypeMap()[entity.loadType!]!
        editedQuantityType = quantityTypeMap()[entity.quantityType!]!
        editedSetLoad = entity.formattedSetLoad!
        editedSetQuantity = entity.formattedSetQuantity!
        editedRestTime = entity.formattedRestTime
    }
    
    public func saveEdits(entity: TemplateSet, viewContext: NSManagedObjectContext) -> Void {
        
        if editedSetName != entity.timePeriodName {
            entity.timePeriodName = editedSetName
        }
        
        if editedSetDesc != entity.timePeriodDescription {
            entity.timePeriodDescription = editedSetDesc
        }
        
        if Double(editedSetLoad)! != entity.setLoad {
            entity.setLoad = Double(editedSetLoad)!
        }
        
        if Double(editedSetQuantity) != entity.setQuantity {
            entity.setQuantity = Double(editedSetQuantity)!
        }
        
        if selectedExercise!.exerciseName != entity.exercise!.exerciseName {
            entity.exercise = selectedExercise
        }
        
        if typeMap[editedLoadType] != entity.loadType {
            entity.loadType = typeMap[editedLoadType]!
        }
        
        if typeMap[editedQuantityType] != entity.quantityType {
            entity.quantityType = typeMap[editedQuantityType]!
        }
        
        if editedSetPositionIndex != entity.positionIndex {
            entity.switchPositionIndex(to: editedSetPositionIndex)
        }
        
        if Double(editedRestTime)! != entity.restTime {
            entity.restTime = Double(editedRestTime)!
        }
        
        if entity.hasChanges {
            entity.propogateChanges()
            withAnimation { showSetChangedAlert = true }
            self.save(viewContext)
        } else {
            withAnimation { showNoChangeAlert = true }
        }

    }
    
    /// Find all the positionIndexes of the other set-children of this sets session.
    public func positionIndexes(selectedTemplateSet: TemplateSet) -> [Int64] {
        return selectedTemplateSet.getPositionIndexes()
    }
    
    /// Func that returns load type selections.
    public func loadTypeSelections() -> [String] {
        switch selectedExercise?.exerciseType {
        case "reps":
            return ["Numerical",
                    "Percentage of current 1RM PR",
                    "Percentage of current body weight"]
        case "time":
            return ["Numerical",
                    "Percentage of current TimeMax PR",
                    "Percentage of current body weight"]
        default:
            return []
        }
    }
    
    /// Func that returns quantity type selections.
    public func quantityTypeSelections() -> [String] {
        switch selectedExercise?.exerciseType {
        case "reps":
            return ["Numerical",
                    "Percentage of current AMRAP PR"]
        case "time":
            return ["Numerical",
                    "Percentage of current TimeMax PR"]
        default:
            return []
        }
    }
    
    /// Func that returns map that maps NSManagedObject attributes to the correct display value.
    public func loadTypeMap() -> [String : String] {
        if selectedExercise?.exerciseType == "reps" {
            return [
                "numerical" : "Numerical",
                "maxperc" : "Percentage of current 1RM PR",
                "bwperc" : "Percentage of current body weight"
            ]
        } else {
            return [
                "maxperc" : "Percentage of current TimeMax PR" ,
                "numerical" : "Numerical"
            ]
        }
    }
    
    /// Func that returns map that maps NSManagedObject attributes to the correct display value.
    public func quantityTypeMap() -> [String : String] {
        if selectedExercise?.exerciseType == "reps" {
            return [
                "numerical" : "Numerical",
                "maxperc" : "Percentage of current AMRAP PR"
            ]
        } else {
            return [
                "maxperc" : "Percentage of current TimeMax PR" ,
                "numerical" : "Numerical"
            ]
        }
    }
    
    /// Func that returns the load placeholder.
    public func loadPlaceholder(viewContext: NSManagedObjectContext) -> String {
        switch editedLoadType {
        case "Numerical":
            let weightUnit = self.weightUnit(viewContext)
            return "Load \(weightUnit)"
        case "Percentage of current 1RM PR":
            return "Percentage"
        case "Percentage of current TimeMax PR":
            return "Percentage"
        case "Percentage of current body weight":
            return "Percentage"
        default:
            return "Select exercise first!"
        }
    }
    
    /// Func that returns variable for the quantity placeholder.
    public func quantityPlaceholder() -> String {
        switch editedQuantityType {
        case "Numerical":
            let exerciseType = selectedExercise?.exerciseType
            if exerciseType == nil {return "Select exercise first!"}
            return exerciseType == "reps" ? "Reps" : "Seconds"
        case "Percentage of current AMRAP PR":
            return "Percentage"
        case "Percentage of current TimeMax PR":
            return "Percentage"
        default:
            return "Select exercise first!"
        }
    }

    /* This dictionary maps the entered value from
     the view to the correct core data property value */
    let typeMap: [String : String] = [
        "Numerical" : "numerical",
        "Percentage of current 1RM PR" : "maxperc",
        "Percentage of current TimeMax PR" : "maxperc",
        "Percentage of current AMRAP PR" : "maxperc",
        "Percentage of current body weight" : "bwperc"
    ]
}
