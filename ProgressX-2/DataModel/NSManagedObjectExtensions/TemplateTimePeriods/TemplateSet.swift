//
//  TemplateSet.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation

extension TemplateSet: HasOrderable {
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    var setExerciseName: String? {
        return self.exercise!.exerciseName
    }
    
    /// Use this property as the single source of truth for the load, in kg's or lbs, to be done on this set
    var loadTodo: Double {
        let loadTypeEnum = LoadType(rawValue: self.loadType!)!
        
        switch loadTypeEnum {
        case .numerical:
            return self.setLoad
        case .maxPercentage:
            let exercise = self.exercise!
            let prType = exercise.exerciseType == "reps" ? "onerepmax" : "timemax"
            let latestPr = PersistenceController.getLatestPersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                prType: prType
            )
            let computedLoad: Double = (latestPr?.weightLoad ?? 0) * (self.setLoad / 100)
            return computedLoad
        case .bodyWeightPercentage:
            let latestBw = PersistenceController.getLatestBodyEntry(self.managedObjectContext!)
            let computedLoad: Double = (latestBw?.bodyWeight ?? 0) * (self.setLoad / 100)
            return computedLoad
        }
    }
    
    /// Use this property as the single source of truth for the quantity, in reps or seconds, to be done on this set
    var quantityTodo: Double {
        let quantityTypeEnum = QuantityType(rawValue: self.quantityType!)!
        
        switch quantityTypeEnum {
        case .numerical:
            return self.setLoad
        case .maxPercentage:
            let exercise = self.exercise!
            let prType = exercise.exerciseType == "reps" ? "maxreps" : "timemax"
            let latestPr = PersistenceController.getLatestPersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                prType: prType
            )
            let computedLoad: Double = (latestPr?.prQuantity ?? 0) * (self.setQuantity / 100)
            return computedLoad
        }
    }
    
    /// Use this property for printing the load to be done on a set
    var loadTodoString: String {
        switch LoadType(rawValue: loadType!)! {
        case .numerical:
            let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
            return String(format: "%.2f", self.setLoad) + " \(weightUnit)"
        case .maxPercentage:
            return (String(format: "%.2f", self.setLoad) + "% of max")
        case .bodyWeightPercentage:
            return (String(format: "%.2f", self.setLoad) + "% of bodyweight")
        }
    }
    
    /// Use this property for printing the quantity to be done on a set
    var quantityTodoString: String {
        switch QuantityType(rawValue: self.quantityType!)! {
            case .numerical:
                switch ExerciseType(rawValue: self.exercise!.exerciseType!)! {
                    case .Reps:
                        return (String(format: "%.0f", self.setQuantity) + " reps")
                    case .Time:
                        return (String(format: "%.2f", self.setQuantity) + " seconds")
                    }
            case .maxPercentage:
                return (String(format: "%.2f", self.setQuantity) + "% of max")
        }
    }
        
    /// Gets the next position index for the thresholds in this set
    public func getNextPositionIndex() -> Int64 {
        let thresholds: [SetThreshold] = self.thresholds?.allObjects as! [SetThreshold]
        let max = thresholds.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // MARK: Validation
    
    // Override validation
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateQuantityTodo()
        try validatePositionIndexes()
    }
    
    // Override validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateQuantityTodo()
        try validatePositionIndexes()
    }
    
    private func validatePositionIndexes() throws {
        let thresholds: [SetThreshold] = self.thresholds?.allObjects as! [SetThreshold]
        let groupedBy = Dictionary(grouping: thresholds, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoIsInvalid.toNSError()
        }
    }
}
