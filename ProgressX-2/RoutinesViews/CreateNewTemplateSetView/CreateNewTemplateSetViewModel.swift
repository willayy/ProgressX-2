//
//  CreateNewTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewTemplateSetViewModel: ViewModel, AddingViewModel {
    
    // The Name of the set (good default is provided)
    @Published public var newSetName: String = "Set "
    
    // The Description of the set (Optional)
    @Published public var newSetDesc: String = ""
    
    // The Load of the set
    @Published public var newSetLoad: String = ""
    
    // The Quantity of the set
    @Published public var newSetQuantity: String = ""
    
    // The rest time
    @Published public var restTime: String = ""
    
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
    
    /* variable that keeps track of if the set has been saved,
     without this its possible to create several identical sets
     by goingback and forth between the add threshold view and this view. */
    @Published public var newSetHasBeenSaved: Bool = false
    
    @Published public var showSetHasBeenSaved: Bool = false
    
    // for load type selections
    var loadTypeSelections: [String] {
        
        switch selectedExercise?.exerciseType {
            
        case "reps":
            return ["Numerical",
                    "Percentage of 1RM PR",
                    "Percentage of body weight"]
            
        case "time":
            return ["Numerical",
                    "Percentage of TimeMax PR",
                    "Percentage of body weight"]
            
        default:
            return []
        }
    }
    
    // for quantity type selections
    var quantityTypeSelections: [String] {
        
        switch selectedExercise?.exerciseType {
            
        case "reps":
            return ["Numerical",
                    "Percentage of AMRAP PR"]
            
        case "time":
            return ["Numerical",
                    "Percentage of TimeMax PR"]
            
        default:
            return []
        }
    }
    
    // for the load placeholder
    public func loadPlaceholder(viewContext: NSManagedObjectContext) -> String {
        
        switch selectedLoadType {
            
        case "Numerical":
            let weightUnit = self.weightUnit(viewContext)
            
            return "Load \(weightUnit)"
            
        case "Percentage of 1RM PR":
            return "Percentage"
            
        case "Percentage of TimeMax PR":
            return "Percentage"
            
        case "Percentage of body weight":
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
            
        case "Percentage of AMRAP PR":
            return "Percentage"
            
        case "Percentage of TimeMax PR":
            return "Percentage"
            
        default:
            return "Select exercise first!"
            
        }
    }
    
    /* This dictionary maps the entered value from
     the view to the correct core data property value */
    let typeMap: [String : String] = [
        "Numerical" : "numerical",
        "Percentage of 1RM PR" : "maxperc",
        "Percentage of TimeMax PR" : "maxperc",
        "Percentage of AMRAP PR" : "maxperc",
        "Percentage of body weight" : "bwperc"
    ]
    
    public func setViewStartValues(viewContext: NSManagedObjectContext) -> Void {
        let profile = CoreDataAccess.getProfile(viewContext)!
        restTime = profile.formattedStandardRestTime
        newSetName = "Set \(selectedTemplateSession!.getNextPositionIndex())"
    }
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        if !newSetHasBeenSaved {
            
            let set = TemplateSet(
                viewContext,
                templateSession: selectedTemplateSession!,
                name: newSetName,
                exercise: selectedExercise!,
                loadType: typeMap[selectedLoadType]!,
                load: Double(newSetLoad)!,
                quantityType: typeMap[selectedQuantityType]!,
                quantity: Double(newSetQuantity)!,
                restTime: Double(restTime)!
            )
            
            let trainingSessions = selectedTemplateSession!.trainingSessions?.allObjects as! [TrainingSession]
            
            for session in trainingSessions {
                
                let _ = TrainingSet(
                    viewContext,
                    trainingSession: session,
                    templateSet: set
                )
                
            }
            
            self.save(viewContext)
            
            withAnimation {
                
                showAddThresholds = true
                
                newSetHasBeenSaved = true
                
            }
            
            self.createdTemplateSet = set
            
            // The new set has been saved once
            
        } else {
            
            withAnimation {
                
                showSetHasBeenSaved = true
                
            }
            
        }
    }
    
}
