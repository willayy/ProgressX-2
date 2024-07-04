//
//  Set.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation

extension TrainingSet {
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    var setExerciseName: String? {
        return self.exercise!.exerciseName
    }
    
    /// Convenience method for getting the load todo on a Set.
    /// - Returns: The load todo as a formatted String.
    var loadTodoString: String {
        return String(format: "%.2f", self.loadTodo)
    }
    
    /// Convenience method for getting the quantity todo on a Set.
    /// - Returns: The quantity todo as a formatted String.
    var quantityTodoString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
        switch type {
        case .Reps:
            return String(format: "%.0f", self.quantityTodo)
        case .Time:
            return String(format: "%.2f", self.quantityTodo)
        }
    }
    
    /// Convenience method for getting the load done on a Set.
    /// - Returns: The load done as a formatted String.
    var loadDoneString: String {
        return String(format: "%.2f", self.loadDone)
    }
    
    /// Convenience method for getting the quantity done on a Set.
    /// - Returns: The quantity done as a formatted String.
    var quantityDoneString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.quantityDone)
            case .Time:
                return String(format: "%.2f", self.quantityDone)
        }
    }
    
    // Returns the quantity unit of the set
    var quantityUnit: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return "reps"
            case .Time:
                return "seconds"
        }
    }
    
    // MARK: Validation
    
    // Override validation
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateQuantityTodo()
        try validateQuantityDone()
    }
    
    // Override validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateQuantityTodo()
        try validateQuantityDone()
    }

    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoInvalid.toNSError()
        }
    }
    
    private func validateQuantityDone() throws {
        let isQuantityDoneInteger = (floor(self.quantityDone) == self.quantityDone)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityDoneInteger && isPrRepBased {
            throw ValidationNSErrors.quantityDoneInvalid.toNSError()
        }
    }
}

extension TemplateSet: HasOrderable {
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    var setExerciseName: String? {
        return self.exercise!.exerciseName
    }
    
    /// An attribute that is the single source of truth for the load todo on a set
    var loadTodo: Double {
        switch loadType {
            case "numerical":
                return self.setLoad
            case "maxperc":
                let exercise = self.exercise!
                let prType = exercise.exerciseType == "reps" ? "onerepmax" : "timemax"
                let latestPr = PersistenceController.getLatestPersonalRecord(
                    self.managedObjectContext!,
                    exercise: exercise,
                    prType: prType
                )
                let computedLoad: Double = (latestPr?.weightLoad ?? 0) * (self.setLoad / 100)
                return computedLoad
            case "bwperc":
                let latestBw = PersistenceController.getLatestBodyEntry(self.managedObjectContext!)
                let computedLoad: Double = (latestBw?.bodyWeight ?? 0) * (self.setLoad / 100)
                return computedLoad
            default:
                return 0
        }
    }
    
    /// An attribute that is the single source of truth for the quantity todo on a set
    var quantityTodo: Double {
        switch quantityType {
            case "numerical":
                return self.setLoad
            case "maxperc":
                let exercise = self.exercise!
                let prType = exercise.exerciseType == "reps" ? "maxreps" : "timemax"
                let latestPr = PersistenceController.getLatestPersonalRecord(
                    self.managedObjectContext!,
                    exercise: exercise,
                    prType: prType
                )
                let computedLoad: Double = (latestPr?.prQuantity ?? 0) * (self.setQuantity / 100)
                return computedLoad
            default:
                return 0
        }
    }
    
    /// Convenience method for getting the load todo on a Set.
    /// - Returns: The load todo as a formatted String.
    var loadTodoString: String {
        switch loadType {
            case "numerical":
                let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
                return String(format: "%.2f", self.setLoad) + " \(weightUnit)"
            case "maxperc":
                return (String(format: "%.2f", self.setLoad) + "% of max")
            case "bwperc":
                return (String(format: "%.2f", self.setLoad) + "% of bodyweight")
            default:
                return "NAN"
        }
    }
    
    /// Convenience method for getting the quantity todo on a Set.
    /// - Returns: The quantity todo as a formatted String.
    var quantityTodoString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
        switch quantityType {
            case "numerical":
                switch type {
                    case .Reps:
                        return String(format: "%.0f", self.setQuantity) + " reps"
                    case .Time:
                        return String(format: "%.2f", self.setQuantity) + " seconds"
                }
            case "maxperc":
                return (String(format: "%.2f", self.setQuantity) + "% of max")
            default:
                return "NAN"
        }
    }
    
    // gets the next position index for the thresholds
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
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
    
    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoInvalid.toNSError()
        }
    }
}
