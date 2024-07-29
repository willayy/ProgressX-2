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
    // The rest time
    @Published var restTime: String = ""
    @Published var restTimeIsInvalid: Bool = false
    @Published var restTimeIsInvalidMsg: String = ""
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
                    "Percentage of current 1RM PR load",
                    "Percentage of current body weight"]
        case "time":
            return ["Numerical",
                    "Percentage of current TimeMax PR load",
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
                    "Percentage of current AMRAP PR reps"]
        case "time":
            return ["Numerical",
                    "Percentage of current TimeMax PR time"]
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
        case "Percentage of current 1RM PR load":
            return "Percentage"
        case "Percentage of current TimeMax PR load":
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
        case "Percentage of current AMRAP PR reps":
            return "Percentage"
        case "Percentage of current TimeMax PR time":
            return "Percentage"
        default:
            return "Select exercise first!"
        }
    }
    
    /* This dictionary maps the entered value from
     the view to the correct core data property value */
    let typeMap: [String : String] = [
        "Numerical" : "numerical",
        "Percentage of current 1RM PR load" : "maxperc",
        "Percentage of current TimeMax PR load" : "maxperc",
        "Percentage of current AMRAP PR reps" : "maxperc",
        "Percentage of current body weight" : "bwperc"
    ]
    
    public func setViewStartValues(viewContext: NSManagedObjectContext) -> Void {
        let profile = PersistenceController.getProfile(viewContext)!
        restTime = profile.standardRestTimeString
    }
    
    public func createNewTemplateSet(viewContext: NSManagedObjectContext, selectedTemplateSession: TemplateSession) -> TemplateSet {
                
        let set = TemplateSet(
            viewContext,
            templateSession: selectedTemplateSession,
            exercise: selectedExercise!,
            loadType: typeMap[selectedLoadType]!,
            load: Double(newSetLoad)!,
            quantityType: typeMap[selectedQuantityType]!,
            quantity: Double(newSetQuantity)!, 
            restTime: Double(restTime)!
        )
        
        // Get all trainingSessions
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateSession == %@", selectedTemplateSession)
        // Only included incomplete trainingSessions as completed ones are irrelevant for this change
        let trainingSessions = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({ !$0.isComplete })
        
        for session in trainingSessions {
            let _ = TrainingSet(
                viewContext,
                trainingSession: session,
                templateSet: set
            )
        }
        
        PersistenceController.save(viewContext)
        
        withAnimation {
            showAddThresholds = true
        }
        
        return set
    }
    
    public func setNewSetName(selectedTemplateSession: TemplateSession) -> Void {
        newSetName = "Set \(selectedTemplateSession.getNextPositionIndex())"
    }
    
}
