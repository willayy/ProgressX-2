//
//  EditTemplateSetViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-07.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSetViewModel: ViewModel {
    
    // The Name of the set (good default is provided)
    @Published var editedSetName: String = ""
    
    // The Description of the set (Optional)
    @Published var editedSetDesc: String = ""
    
    // The Load of the set
    @Published var editedSetLoad: String = ""
    
    // The Quantity of the set
    @Published var editedSetQuantity: String = ""
    
    // The rest time of the set
    @Published var editedRestTime: String = ""
    
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
        case ExerciseType.Reps.rawValue:
            return ["Numerical",
                    "Percentage of 1RM PR",
                    "Percentage of body weight"]
        case ExerciseType.Time.rawValue:
            return ["Numerical",
                    "Percentage of TimeMax PR",
                    "Percentage of body weight"]
        default:
            return []
        }
    }
    
    /// Func that returns quantity type selections.
    public func quantityTypeSelections() -> [String] {
        switch selectedExercise?.exerciseType {
        case ExerciseType.Reps.rawValue:
            return ["Numerical",
                    "Percentage of AMRAP PR"]
        case ExerciseType.Time.rawValue:
            return ["Numerical",
                    "Percentage of TimeMax PR"]
        default:
            return []
        }
    }
    
    /// Func that returns map that maps NSManagedObject attributes to the correct display value.
    public func loadTypeMap() -> [String : String] {
        if selectedExercise?.exerciseType == ExerciseType.Reps.rawValue {
            return [
                LoadType.numerical.rawValue : "Numerical",
                LoadType.maxPercentage.rawValue : "Percentage of 1RM PR",
                LoadType.bodyWeightPercentage.rawValue : "Percentage of body weight"
            ]
        } else {
            return [
                LoadType.maxPercentage.rawValue : "Percentage of TimeMax PR" ,
                LoadType.numerical.rawValue : "Numerical"
            ]
        }
    }
    
    /// Func that returns map that maps NSManagedObject attributes to the correct display value.
    public func quantityTypeMap() -> [String : String] {
        if selectedExercise?.exerciseType == ExerciseType.Reps.rawValue {
            return [
                QuantityType.numerical.rawValue : "Numerical",
                QuantityType.maxPercentage.rawValue : "Percentage of AMRAP PR"
            ]
        } else {
            return [
                QuantityType.maxPercentage.rawValue : "Percentage of TimeMax PR" ,
                QuantityType.numerical.rawValue : "Numerical"
            ]
        }
    }
    
    /// Func that returns the load placeholder.
    public func loadPlaceholder(viewContext: NSManagedObjectContext) -> String {
        switch editedLoadType {
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
    
    /// Func that returns variable for the quantity placeholder.
    public func quantityPlaceholder() -> String {
        switch editedQuantityType {
        case "Numerical":
            let exerciseType = selectedExercise?.exerciseType
            if exerciseType == nil {return "Select exercise first!"}
            return exerciseType == ExerciseType.Reps.rawValue ? "Reps" : "Seconds"
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
        "Numerical" : LoadType.numerical.rawValue,
        "Percentage of 1RM PR" : LoadType.maxPercentage.rawValue,
        "Percentage of TimeMax PR" : LoadType.maxPercentage.rawValue,
        "Percentage of AMRAP PR" : QuantityType.maxPercentage.rawValue,
        "Percentage of body weight" : LoadType.bodyWeightPercentage.rawValue
    ]
}
