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
        try validateExercise()
        try validatePrType()
        try validateQuantityTodo()
        try validateQuantityDone()
    }
    
    // Override validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateExercise()
        try validatePrType()
        try validateQuantityTodo()
        try validateQuantityDone()
    }
    
    // Makes sure that the Set has an Exercise assigned to it.
    private func validateExercise() throws {
        if self.exercise == nil {
            throw ValidationNSErrors.setExerciseIsNil.toNSError()
        }
    }
    
    // Makes sure that the Set has an Exercise that matches it's own type.
    private func validatePrType() throws {
        let prToExerciseTypeMap = [
            "onerepmax" : "reps",
            "maxreps" : "reps",
            "timemax" : "time"
        ]
        
        if prToExerciseTypeMap[self.prType!] != self.exercise!.exerciseType {
            throw ValidationNSErrors.setAndExerciseTypeMismatch.toNSError()
        }
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
