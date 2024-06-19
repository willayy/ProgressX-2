//
//  Set.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation

extension TrainingSet {
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    @objc public func exerciseString() -> String? {
        guard let name = self.exercise!.exerciseName else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        return name
    }
    
    /// Convenience method for getting the load todo on a Set.
    /// - Returns: The load todo as a formatted String.
    @objc public func loadTodoString() -> String {
        return String(format: "%.2f", self.loadTodo)
    }
    
    /// Convenience method for getting the quantity todo on a Set.
    /// - Returns: The quantity todo as a formatted String.
    @objc public func quantityTodoString() -> String {
        guard let type = self.exercise!.exerciseType else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        switch type {
            case "reps":
                return String(format: "%.0f", self.quantityTodo)
            case "time":
                return String(format: "%.2f", self.quantityTodo)
            default:
                return ""
        }
    }
    
    /// Convenience method for getting the load done on a Set.
    /// - Returns: The load done as a formatted String.
    @objc public func loadDoneString() -> String {
        return String(format: "%.2f", self.loadDone)
    }
    
    /// Convenience method for getting the quantity done on a Set.
    /// - Returns: The quantity done as a formatted String.
    @objc public func quantityDoneString() -> String {
        guard let type = self.exercise!.exerciseType else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        switch type {
            case "reps":
                return String(format: "%.0f", self.quantityDone)
            case "time":
                return String(format: "%.2f", self.quantityDone)
            default:
                return ""
        }
    }
    
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
            throw ProgressXNSErrors.setExerciseIsNil.toNSError()
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
            throw ProgressXNSErrors.setAndExerciseTypeMismatch.toNSError()
        }
    }

    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo) == self.quantityTodo)
        let isPrRepBased = (self.prType == "onerepmax" || self.prType == "maxreps")

        if !isQuantityTodoInteger && isPrRepBased {
            throw ProgressXNSErrors.quantityTodoInvalid.toNSError()
        }
    }
    
    private func validateQuantityDone() throws {
        let isQuantityDoneInteger = (floor(self.quantityDone) == self.quantityDone)
        let isPrRepBased = (self.prType == "onerepmax" || self.prType == "maxreps")
        
        if !isQuantityDoneInteger && isPrRepBased {
            throw ProgressXNSErrors.quantityDoneInvalid.toNSError()
        }
    }
    
}
