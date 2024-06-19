//
//  PersonalRecordExtensions.swift
//  ProgressX-Experiments
//
//  Created by William Norland on 2024-06-08.
//

import Foundation

extension PersonalRecord {
    
    /// The unit supposed to be used when describing the quantity of the PR
    /// - Returns: A String
    @objc public func quantityUnitString() -> String {
        switch self.prType {
            case "maxreps":
                return "reps"
            case "onerepmax":
                return "reps"
            case "timemax":
                return "seconds"
            default:
                return ""
        }
    }
    
    /// Formatted prQuantity String  from the PR
    /// - Returns: String(Double) formatted into 0 or 2 decimal points depending on PR-type
    @objc public func quantityString() -> String {
        switch self.prType {
            case "maxreps":
                return String(format: "%.0f", self.prQuantity)
            case "onerepmax":
                return String(format: "%.0f", self.prQuantity)
            case "timemax":
                return String(format: "%.2f", self.prQuantity)
            default:
                return ""
        }
    }
    
    /// A prettier string than the raw one stored in the CoreData entities.
    /// - Returns: A pretty-fied String
    @objc public func typeString() -> String {
        switch self.prType {
            case "maxreps":
                return "AMRAP"
            case "onerepmax":
                return "1RM"
            case "timemax":
                return "Time-max"
            default:
                return ""
        }
    }
    
    /// Formatted weightLoad String from PR
    /// - Returns: String(Double) formatted to two decimal points.
    @objc public func loadString() -> String {
        return String(format: "%.2f", self.weightLoad)
    }
    
    // Overriding update for special constraints
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateExercise()
        try validatePrType()
        try validateQuantity()
    }
    
    // Overriding insert for special constraints
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateExercise()
        try validatePrType()
        try validateQuantity()
    }
    
    // Func that validates that the quantity of a PersonalRecord needs to be a valid Integer if the PersonalRecord is repbased.
    private func validateQuantity() throws {
        let isQuantityInteger = (floor(self.prQuantity) == self.prQuantity)
        let isPrRepBased = (self.prType == "onerepmax" || self.prType == "maxreps")

        if !isQuantityInteger && isPrRepBased {
            throw ProgressXNSErrors.prAndExerciseTypeMismatch.toNSError()
        }
    }
    
    /* Func that validates the exericse relationship in a PersonalRecord entity */
    private func validateExercise() throws {
        if self.exercise == nil {
            throw ProgressXNSErrors.prExerciseIsNil.toNSError()
        }
    }
    
    /* Function that validates a relationship between the prType property and the
    related Exercises object (exercise relationship) */
    private func validatePrType() throws {
        let prToExerciseTypeMap = [
            "onerepmax" : "reps",
            "maxreps" : "reps",
            "timemax" : "time"
        ]
        
        /* If a PersonalRecord has a relationship to an exercise that does not have
        the a matching type throw an Error*/
        if prToExerciseTypeMap[self.prType!] != self.exercise!.exerciseType {
            throw ProgressXNSErrors.prAndExerciseTypeMismatch.toNSError()
        }
    }
        
}
