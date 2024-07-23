//
//  Threshold.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import Foundation
import CoreData

extension SetThreshold {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        templateSet: TemplateSet,
        name: String = "",
        description: String = "",
        triggeredAt: Double,
        generatesPr: Bool,
        prType: String?,
        flatLoadAdd: NSNumber?,
        flatQuantityAdd: NSNumber?
    ) {
        self.init(context: context)
        self.templateSet = templateSet
        self.triggerQuantity = triggeredAt
        self.generatePr = generatesPr
        self.prType = prType
        self.flatLoadAdd = flatLoadAdd
        self.flatQuantityAdd = flatLoadAdd
        let positionIndex = templateSet.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Threshold \(positionIndex)" : name
        let setName = templateSet.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Threshold in \(setName)" : description
        templateSet.addToThresholds(self)
    }
    
    // MARK: Extra Properties
    
    public var flatLoadAddString: String {
        if self.flatQuantityAdd == nil { return ""}
        let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
        return String(format: "%.2f", self.flatLoadAdd?.doubleValue ?? 0) + " \(weightUnit)"
    }
    
    public var flatQuantityAddString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        if self.flatQuantityAdd == nil { return ""}
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.flatQuantityAdd?.doubleValue ?? 0) + " reps"
            case .Time:
                return String(format: "%.2f", self.flatQuantityAdd?.doubleValue ?? 0) + " seconds"
        }
    }
    
    /// Use this property to get a correctly formatted string from the  triggerQuantity value
    public var triggerQuantityString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.templateSet!.exercise!.exerciseType!)!
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.triggerQuantity) + " reps"
            case .Time:
                return String(format: "%.2f", self.triggerQuantity) + " seconds"
        }
    }
        
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validatePrTypeMatch()
        try validateTriggerQuantity()
        try validateFlatLoadAdd()
        try validateFlatQuantityAdd()
        try validatePrTypeValue()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePrTypeMatch()
        try validateTriggerQuantity()
        try validateFlatLoadAdd()
        try validateFlatQuantityAdd()
        try validatePrTypeValue()
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
    private func validatePrTypeMatch() throws {
        let prToExerciseTypeMap = [
            "onerepmax" : "reps",
            "maxreps" : "reps",
            "timemax" : "time"
        ]
        
        if self.prType == nil {
            return
        }
        
        let mappedPrType = prToExerciseTypeMap[self.prType!]
        let exerciseType = self.templateSet!.exercise!.exerciseType
        
        if mappedPrType != exerciseType {
            throw ValidationNSErrors.setAndExerciseTypeMismatch.toNSError()
        }
    }
    
    private func validatePrTypeValue() throws {
        if self.generatePr && self.prType == nil {
            throw ValidationNSErrors.prTypeValueIsInvalid.toNSError()
        } else if !self.generatePr && self.prType != nil {
            throw ValidationNSErrors.prTypeValueIsInvalid.toNSError()
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
