//
//  PersonalRecordExtensions.swift
//  ProgressX-Experiments
//
//  Created by William Norland on 2024-06-08.
//

import Foundation

extension PersonalRecord {
    
    //MARK: Extra properties
    
    var quantityUnitString: String {
        let type: PersonalRecordType = PersonalRecordType(rawValue: self.prType!)!
        
        switch type {
        case .MaxReps:
            return "reps"
        case .OneRepMax:
            return "reps"
        case .TimeMax:
            return "seconds"
        }
    }
    
    var quantityString: String {
        let type: PersonalRecordType = PersonalRecordType(rawValue: self.prType!)!
        
        switch type {
        case .MaxReps:
            return String(format: "%.0f", self.prQuantity)
        case .OneRepMax:
            return String(format: "%.0f", self.prQuantity)
        case .TimeMax:
            return String(format: "%.2f", self.prQuantity)
        }
    }
   
    var typeString: String {
        let type: PersonalRecordType = PersonalRecordType(rawValue: self.prType!)!
        
        switch type {
        case .MaxReps:
            return "AMRAP"
        case .OneRepMax:
            return "1RM"
        case .TimeMax:
            return "Time-max"
        }
    }
   
    var loadString: String {
        return String(format: "%.2f", self.weightLoad)
    }
    
    //MARK: Validation
    
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
            throw ValidationNSErrors.prAndExerciseTypeMismatch.toNSError()
        }
    }
    
    /* Func that validates the exericse relationship in a PersonalRecord entity */
    private func validateExercise() throws {
        if self.exercise == nil {
            throw ValidationNSErrors.prExerciseIsNil.toNSError()
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
            throw ValidationNSErrors.prAndExerciseTypeMismatch.toNSError()
        }
    }
        
}
