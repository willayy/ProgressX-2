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
    
    /// A prettier string to the the type of the PR
    /// - Returns: A pretty String
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
    
    // Overriding the willSavde to make sure that prType always matches exerciseType.
    public override func willSave() {
        super.willSave()
        let prToExerciseTypeMap = [
            "onerepmax" : "reps",
            "maxreps" : "reps",
            "timemax" : "time"
        ]
        
        if prToExerciseTypeMap[self.prType!] != self.exercise!.exerciseType {
            let error = NSError(
                domain: "CoreDataErrorDomain",
                code: 9999,
                userInfo: [NSLocalizedDescriptionKey: "Pr type string does not match exercise type string."]
            )
            self.setPrimitiveValue(error, forKey: "validationError")
        }
        
    }
    
}
