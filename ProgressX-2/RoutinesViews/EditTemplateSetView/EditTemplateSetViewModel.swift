//
//  EditTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-07.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSetViewModel: ObservableObject {
    
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
    
    public func setViewStartValues(selectedTemplateSet: TemplateSet?) -> Void {
        editedSetName = selectedTemplateSet!.timePeriodName!
        editedSetDesc = selectedTemplateSet!.timePeriodDescription!
        editedSetPositionIndex = selectedTemplateSet!.positionIndex
        selectedExercise = selectedTemplateSet!.exercise!
        editedLoadType = loadTypeMap()[selectedTemplateSet!.loadType!]!
        editedQuantityType = quantityTypeMap()[selectedTemplateSet!.quantityType!]!
        editedSetLoad = selectedTemplateSet!.loadTodoString
        editedSetQuantity = selectedTemplateSet!.quantityTodoString
    }
    
    public func saveTemplateSetChanges(viewContext: NSManagedObjectContext, selectedTemplateSet: TemplateSet?) -> Void {
        
        if editedSetName != selectedTemplateSet!.timePeriodName {
            selectedTemplateSet!.timePeriodName = editedSetName
        }
        
        if editedSetDesc != selectedTemplateSet!.timePeriodDescription {
            selectedTemplateSet!.timePeriodDescription = editedSetDesc
        }
        
        if Double(editedSetLoad)! != selectedTemplateSet!.setLoad {
            selectedTemplateSet!.setLoad = Double(editedSetLoad)!
        }
        
        if Double(editedSetQuantity) != selectedTemplateSet!.setQuantity {
            selectedTemplateSet!.setQuantity = Double(editedSetQuantity)!
        }
        
        if selectedExercise!.exerciseName != selectedTemplateSet!.exercise!.exerciseName {
            selectedTemplateSet!.exercise = selectedExercise
        }
        
        if typeMap[editedLoadType] != selectedTemplateSet!.loadType {
            selectedTemplateSet!.loadType = typeMap[editedLoadType]!
        }
        
        if typeMap[editedQuantityType] != selectedTemplateSet!.quantityType {
            selectedTemplateSet!.quantityType = typeMap[editedQuantityType]!
        }
        
        if editedSetPositionIndex != selectedTemplateSet!.positionIndex {
            selectedTemplateSet!.positionIndex = editedSetPositionIndex
        }
        
        if selectedTemplateSet!.hasChanges {
            withAnimation {
                showSetChangedAlert = true
                PersistenceController.save(viewContext)
            }
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }

    }
    
    // Find all the positionIndexes of the other set-children of this sets session
    public func positionIndexes(selectedTemplateSet: TemplateSet?) -> [Int64] {
        let session = selectedTemplateSet!.templateSession!
        let sets = session.templateSets!.allObjects as! [TemplateSet]
        let positionIndexes = sets.map { set in
            set.positionIndex
        }
        return positionIndexes
    }
    
    // func that returns load type selections
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
    
    // func that returns quantity type selections
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
    
    // func that returns map that maps NSManagedObject attributes to the correct display value
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
    
    // func that returns map that maps NSManagedObject attributes to the correct display value
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
    
    // func that returns the load placeholder
    public func loadPlaceholder(viewContext: NSManagedObjectContext) -> String {
        switch editedLoadType {
        case "Numerical":
            let weightUnit = PersistenceController.getWeightUnit(viewContext)!
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
    
    // func that returns variable for the quantity placeholder
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
