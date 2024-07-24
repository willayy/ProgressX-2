//
//  PersonalRecordExtensions.swift
//  ProgressX-Experiments
//
//  Created by William Norland on 2024-06-08.
//

import Foundation
import CoreData

extension PersonalRecord {
    
    // MARK: Convenience initializer
    
    convenience init(
        _ context: NSManagedObjectContext,
        exercise: Exercise,
        weightLoad: Double,
        quantity: Double,
        date: Date,
        type: String
    ) {
        self.init(context: context)
        self.exercise = exercise
        self.weightLoad = weightLoad
        self.prQuantity = quantity
        self.achievedOnDate = date
        self.prType = type
        exercise.addToPersonalRecords(self)
    }
    
    //MARK: Extra properties
    
    /// Returns the formatted quantity of a personal record as a string, returns nil if prType is not set or is invalid.
    public var quantityString: String? {
        guard let prType = self.prType else { return nil }
        guard let type: PersonalRecordType = PersonalRecordType(rawValue: prType) else { return nil }
        
        switch type {
        case .MaxReps:
            return String(format: "%.0f", self.prQuantity) + " reps"
        case .OneRepMax:
            return String(format: "%.0f", self.prQuantity) + " reps"
        case .TimeMax:
            return String(format: "%.2f", self.prQuantity) + " seconds"
        }
    }
   
    /// Retruns the formatted quantity of a personal record as a string, returns nil if prType is not set or is invalid.
    public var typeString: String? {
        guard let prType = self.prType else { return nil }
        guard let type: PersonalRecordType = PersonalRecordType(rawValue: prType) else { return nil }
        
        switch type {
        case .MaxReps:
            return "AMRAP"
        case .OneRepMax:
            return "1RM"
        case .TimeMax:
            return "Time-max"
        }
    }
   
    /// Returns the formatted load of a personal record as a string, returns nil if context or weight unit (Profile) is not set.
    public var loadString: String? {
        guard let context = self.managedObjectContext else { return nil }
        guard let weightUnit = PersistenceController.getWeightUnit(context) else { return nil }
        return String(format: "%.2f", self.weightLoad) + " \(weightUnit)"
    }
    
    //MARK: Validation
    
    // Overriding update for special constraints
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePrType()
        try validateQuantity()
    }
    
    // Overriding insert for special constraints
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validatePrType()
        try validateQuantity()
    }
    
    // Func that validates that the quantity of a PersonalRecord needs to be a valid Integer if the PersonalRecord is repbased.
    private func validateQuantity() throws {
        let isQuantityInteger = (floor(self.prQuantity) == self.prQuantity)
        let isPrRepBased = (self.prType == "onerepmax" || self.prType == "maxreps")

        if !isQuantityInteger && isPrRepBased {
            throw ValidationNSErrors.prQuantityIsInvalid.toNSError()
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
