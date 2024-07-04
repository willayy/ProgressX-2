//
//  Threshold.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import Foundation

extension SetThreshold {
    
    // MARK: Extra Properties
    
    public var formattedFlatLoadAdd: String {
        return String(format: "%.2f", self.flatLoadAdd?.doubleValue ?? 0)
    }
    
    public var formattedFlatQuantityAdd: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.flatQuantityAdd?.doubleValue ?? 0)
            case .Time:
                return String(format: "%.2f", self.flatQuantityAdd?.doubleValue ?? 0)
        }
    }
    
    public var flatQuantityUnit: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return "reps"
            case .Time:
                return "seconds"
        }
    }
    
    // Gives a correctly formatted string from the quantity value
    public var formattedTriggerQuantity: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.triggerQuantity)
            case .Time:
                return String(format: "%.2f", self.triggerQuantity)
        }
    }
    
    public var triggerQuantityUnit: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return "reps"
            case .Time:
                return "seconds"
        }
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validatePrType()
        try validateTriggerQuantity()
        try validateFlatLoadAdd()
        try validateFlatQuantityAdd()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePrType()
        try validateTriggerQuantity()
        try validateFlatLoadAdd()
        try validateFlatQuantityAdd()
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
    
    private func validateFlatLoadAdd() throws {
        let set = self.templateSet!
        if set.loadType != "numerical" && self.flatLoadAdd != nil {
            throw ValidationNSErrors.flatLoadAddIsInvalid.toNSError()
        }
    }
    
    private func validateFlatQuantityAdd() throws {
        let set = self.templateSet!
        if set.quantityType != "numerical" && self.flatQuantityAdd != nil {
            throw ValidationNSErrors.flatQuantityAddIsInvalid.toNSError()
        }
    }
    
}
