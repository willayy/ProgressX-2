//
//  Threshold.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import Foundation
import CoreData

extension SetThreshold: HasParent {
    
    //MARK: Convenience init
    
    public convenience init(
        _ context: NSManagedObjectContext,
        templateSet: TemplateSet,
        name: String = "",
        description: String = "",
        upperBound: Double,
        lowerBound: Double,
        generatesPr: Bool,
        prType: String?,
        flatLoadAdd: NSNumber?,
        flatQuantityAdd: NSNumber?
    ) {
        self.init(context: context)
        self.templateSet = templateSet
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.generatePr = generatesPr
        self.prType = prType
        self.flatLoadAdd = flatLoadAdd
        self.flatQuantityAdd = flatQuantityAdd
        let positionIndex = templateSet.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Threshold \(positionIndex)" : name
        let setName = templateSet.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Threshold in \(setName)" : description
        templateSet.addToThresholds(self)
    }
    
    /// Initializer for a SetThreshold using JSON data
    public convenience init(
        _ context: NSManagedObjectContext,
        templateSet: TemplateSet,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.templateSet = templateSet
        templateSet.addToThresholds(self)
        self.positionIndex = templateSet.getNextPositionIndex()
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
        
        // JSON data can have a string value or nil.
        let prType = json["prType"]
        self.prType = (prType is NSNull) ? nil : prType as! String?
        
        // Upper and lower bound of the threshold.
        self.upperBound = json["upperBound"] as! Double
        
        self.lowerBound = json["lowerBound"] as! Double
        
        // Flat load and quantity add. Needs some seperate handling because NSNull cant be cast to NSNumber?
        let flatQuantityAdd = json["flatQuantityAdd"]
        self.flatQuantityAdd = (flatQuantityAdd is NSNull) ? nil : flatQuantityAdd as! NSNumber?
        
        let flatLoadAdd = json["flatLoadAdd"]
        self.flatLoadAdd = (flatLoadAdd is NSNull) ? nil : flatLoadAdd as! NSNumber?
        
        // In the JSON files generate PR is an int where 1 is true and 0 (or anthing else) is false.
        self.generatePr = json["generatePr"] as! Bool
    }
    
    // MARK: Protocol implementation
        
    internal typealias ParentType = TemplateSet
    
    // Protocol implementation
    internal var parent: TemplateSet {
        return self.templateSet!
    }
    
    // MARK: Extra Properties
    
    /// FlatLoadAdd value formatted as a String
    public var formattedFlatLoadAdd: String? {
        guard let flatQuantityAdd = self.flatQuantityAdd else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        guard let weightUnit = CoreDataAccess.getWeightUnit(context) else { return nil }
        
        return String(format: "%.2f", flatQuantityAdd) + " \(weightUnit)"
    }
    
    /// flatQuantityAdd value formatted as a String
    public var formattedFlatQuantityAdd: String? {
        guard let templateSet = self.templateSet else { return nil }
        guard let exercise = templateSet.exercise else { return nil }
        guard let exerciseType = exercise.exerciseType else { return nil }
        guard let flatQuantityAdd = self.flatQuantityAdd else { return nil }
        guard let type: ExerciseType = ExerciseType(rawValue: exerciseType) else { return nil }
        
        switch type {
            
            case .Reps:
            
                return String(format: "%.0f", flatQuantityAdd) + " reps"
            
            case .Time:
            
                return String(format: "%.2f", flatQuantityAdd) + " seconds"
        }
    }
    
    /// Use this property to get a correctly formatted string from the  triggerQuantity value
    public var formattedTriggerQuantity: String? {
        
        guard let templateSet = self.templateSet else { return nil }
        guard let exercise = templateSet.exercise else { return nil }
        guard let exerciseType = exercise.exerciseType else { return nil }
        guard let type: ExerciseType = ExerciseType(rawValue: exerciseType) else { return nil }
        
        switch type {
            
            case .Reps:
            
                let upperBound = String(format: "%.0f", self.upperBound)
            
                let lowerBound = String(format: "%.0f", self.lowerBound)
            
                return "Between \(lowerBound) - \(upperBound) reps"
            
            case .Time:
            
                let upperBound = String(format: "%.2f", self.upperBound)
            
                let lowerBound = String(format: "%.2f", self.lowerBound)
            
                return "Between \(lowerBound) - \(upperBound) seconds"
        }
    }
    
    /// Returns true if quantityDone is larger than triggerQuantity.
    internal func isTriggered(quantityDone: Double) -> Bool {
        
        let isAboveLower = (quantityDone >= self.lowerBound)
        
        let isBelowUpper = (quantityDone <= self.upperBound)
        
        return (isAboveLower && isBelowUpper) ? true : false
        
    }
    
    /// Modifies the load of the template set with flatLoadAdd.
    internal func addLoadModifiers() -> Void {
        
        let templateSet = self.templateSet!
        
        let flatLoadAdd: Double = self.flatQuantityAdd?.doubleValue ?? 0
        
        templateSet.setLoad += flatLoadAdd
        
    }
    
    /// Modifies the quantity of the template set with the flatQuantityAdd.
    internal func addQuantityModifiers() -> Void {
        
        let templateSet = self.templateSet!
        
        let flatQuantityAdd: Double = self.flatQuantityAdd?.doubleValue ?? 0
        
        templateSet.setQuantity += flatQuantityAdd
        
        // Also modify trigger quantity to ensure linearity
        self.upperBound += flatQuantityAdd
        
    }
    
    /// Generates a personal record if it's possible.
    internal func generatePersonalRecord(quantityDone: Double, loadDone: Double) -> Void {
        
        if self.generatePr {
            
            let templateSet = self.templateSet!
            
            let exercise = templateSet.exercise!
            
            let computedLoad: Double = {
                
                // if onerepmax pr and load done isnt 1 use Brzyckis formula to approximate
                if self.prType! == "onerepmax" && loadDone != 1 {
                    
                    return (loadDone / (1.0278 - (0.0278 * quantityDone)))
                    
                } else {
                    
                    return loadDone
                    
                }
            }()
            
            let computedQuantity: Double = {
                
                // If prType is onerepmax always set quantityDone to 1
                if self.prType! == "onerepmax" {
                    
                    return 1
                    
                } else {
                    
                    return quantityDone
                    
                }
            }()
            
            // Generate the PersonalRecord.
            _ = PersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                weightLoad: computedLoad,
                quantity: computedQuantity,
                date: Date(),
                type: self.prType!
            )
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
        
        let isUpperBoundInteger = (floor(self.upperBound) == self.upperBound)
        
        let isLowerBoundInteger = (floor(self.lowerBound) == self.lowerBound)
        
        let isPrRepBased = (self.templateSet!.exercise!.exerciseType == "reps")
        
        if !isLowerBoundInteger && !isUpperBoundInteger && isPrRepBased {
            
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
