//
//  CreateNewTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewTemplateSetViewModel: ObservableObject {
    
    // The Name of the set (good default is provided)
    @Published var newSetName: String = "Set "
    @Published var newSetNameIsInvalid: Bool = false
    @Published var newSetNameIsInvalidMsg: String = ""
    // The Description of the set (Optional)
    @Published var newSetDesc: String = ""
    @Published var newSetDescIsInvalid: Bool = false
    @Published var newSetDescIsInvalidMsg: String = ""
    // The Load of the set
    @Published var newSetLoad: String = ""
    @Published var newSetLoadIsInvalid: Bool = false
    @Published var newSetLoadIsInvalidMsg: String = ""
    // The Quantity of the set
    @Published var newSetQuantity: String = ""
    @Published var newSetQuantityIsInvalid: Bool = false
    @Published var newSetQuantityIsInvalidMsg: String = ""
    // The exercise of the set
    @Published var selectedExercise: Exercise? = nil
    @Published var searchWord: String = ""
    // Selection of load types
    @Published var selectedLoadType: String = "Select exercise first!"
    // Selection of quantity types
    @Published var selectedQuantityType: String = "Select exercise first!"
    // State that tracks if an exercises has been selected
    @Published var exerciseHasBeenSelected: Bool = false
    // State that decides if the view should navigate to the add thresholds view
    @Published var showAddThresholds: Bool = false
    
    // for load type selections
    var loadTypeSelections: [String] {
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
    
    // for quantity type selections
    var quantityTypeSelections: [String] {
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
    
    // for the load placeholder
    public func loadPlaceholder(viewContext: NSManagedObjectContext) -> String {
        switch selectedLoadType {
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
    
    // for the quantity placeholder
    var quantityPlaceholder: String {
        switch selectedQuantityType {
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
    
    public func createNewTemplateSet(viewContext: NSManagedObjectContext, selectedTemplateSession: TemplateSession?) -> Void {
        
        let nextPositionIndex = selectedTemplateSession!.getNextPositionIndex()
        
        _ = PersistenceController.createTemplateSet(
            viewContext,
            name: newSetName,
            description: newSetDesc,
            templateSession: selectedTemplateSession!,
            positionIndex: nextPositionIndex,
            exercise: selectedExercise!,
            loadType: typeMap[selectedLoadType]!,
            load: Double(newSetLoad)!,
            quantityType: typeMap[selectedQuantityType]!,
            quantity: Double(newSetQuantity)!
        )

        PersistenceController.save(viewContext)
        
        withAnimation {
            showAddThresholds = true
        }
    }
    
    public func setNewSetName(selectedTemplateSession: TemplateSession?) -> Void {
        newSetName = "Set \(selectedTemplateSession!.getNextPositionIndex())"
    }
    
}
