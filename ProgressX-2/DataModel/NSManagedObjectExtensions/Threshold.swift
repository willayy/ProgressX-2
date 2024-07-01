//
//  Threshold.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import Foundation

extension Threshold {
    
    // MARK: Extra Properties
    
    // Gives a correctly formatted string from the quantity value
    public var triggerQuantityString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.triggerQuantity)
            case .Time:
                return String(format: "%.2f", self.triggerQuantity)
        }
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validatePrType()
        try validateTriggerQuantity()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePrType()
        try validateTriggerQuantity()
    }
    
    // Validates that the trigger quantity matches the exercise of the set
    private func validateTriggerQuantity() throws {
        let isTriggerQuantityInteger = (floor(self.triggerQuantity) == self.triggerQuantity)
        let isPrRepBased = (self.templateSet!.exercise!.exerciseType == "reps")
        if !isTriggerQuantityInteger && isPrRepBased {
            throw ValidationNSErrors.triggerQuantityIsInvalid.toNSError()
        }
    }
    
    // Makes sure that the thresholds sets exercise matches its pr type.
    private func validatePrType() throws {
        let prToExerciseTypeMap = [
            "onerepmax" : "reps",
            "maxreps" : "reps",
            "timemax" : "time"
        ]
        
        if prToExerciseTypeMap[self.prType!] != self.templateSet!.exercise!.exerciseType {
            throw ValidationNSErrors.setAndExerciseTypeMismatch.toNSError()
        }
    }
    
}
