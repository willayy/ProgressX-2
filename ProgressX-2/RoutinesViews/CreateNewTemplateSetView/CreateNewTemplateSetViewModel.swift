//
//  CreateNewTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewTemplateSetViewModel: SavingViewModel, AddingViewModel {
    
    // The Name of the set (good default is provided)
    @Published public var newSetName: String = "Set "
    @Published public var newSetNameIsInvalid: Bool = false
    @Published public var newSetNameIsInvalidMsg: String = ""
    // The Description of the set (Optional)
    @Published public var newSetDesc: String = ""
    @Published public var newSetDescIsInvalid: Bool = false
    @Published public var newSetDescIsInvalidMsg: String = ""
    // The Load of the set
    @Published public var newSetLoad: String = ""
    @Published public var newSetLoadIsInvalid: Bool = false
    @Published public var newSetLoadIsInvalidMsg: String = ""
    // The Quantity of the set
    @Published public var newSetQuantity: String = ""
    @Published public var newSetQuantityIsInvalid: Bool = false
    @Published public var newSetQuantityIsInvalidMsg: String = ""
    // The rest time
    @Published public var restTime: String = ""
    @Published public var restTimeIsInvalid: Bool = false
    @Published public var restTimeIsInvalidMsg: String = ""
    // The exercise of the set
    @Published public var selectedExercise: Exercise? = nil
    @Published public var searchWord: String = ""
    // Selection of load types
    @Published public var selectedLoadType: String = "Select exercise first!"
    // Selection of quantity types
    @Published public var selectedQuantityType: String = "Select exercise first!"
    // State that tracks if an exercises has been selected
    @Published public var exerciseHasBeenSelected: Bool = false
    // State that decides if the view should navigate to the add thresholds view
    @Published public var showAddThresholds: Bool = false
    @Published public var selectedTemplateSession: TemplateSession? = nil
    @Published public var createdTemplateSet: TemplateSet? = nil
    
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
        newSetName = "Set \(selectedTemplateSession!.getNextPositionIndex())"
    }
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
                
        let set = TemplateSet(
            viewContext,
            templateSession: selectedTemplateSession!,
            exercise: selectedExercise!,
            loadType: typeMap[selectedLoadType]!,
            load: Double(newSetLoad)!,
            quantityType: typeMap[selectedQuantityType]!,
            quantity: Double(newSetQuantity)!, 
            restTime: Double(restTime)!
        )
        
        // Get all trainingSessions
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateSession == %@", selectedTemplateSession!)
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
        
        self.safeSave(viewContext: viewContext)
        
        withAnimation {
            showAddThresholds = true
        }
        
        self.createdTemplateSet = set
    }
}
