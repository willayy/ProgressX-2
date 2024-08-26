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
        self.flatQuantityAdd = flatQuantityAdd
        let positionIndex = templateSet.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Threshold \(positionIndex)" : name
        let setName = templateSet.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Threshold in \(setName)" : description
        templateSet.addToThresholds(self)
    }
    
    /// Initializer for a SetThreshold using JSON data
    convenience init(
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
        
        // If JSON data has value "nil" set prType to nil, else set it to its correct literal.
        let prType = json["prType"] as! String
        
        self.prType = ( prType == "nil") ? nil : prType
        
        self.triggerQuantity = (json["triggerQuantity"] as! Double)
        
        // The value in the flatQuantityAdd field should either be a Double or the literal "nil".
        let flatQuantityAdd = json["flatQuantityAdd"]
        
        if flatQuantityAdd is String && (flatQuantityAdd as! String) == "nil"  {
            self.flatQuantityAdd = nil
        } else {
            self.flatQuantityAdd = flatQuantityAdd as! NSNumber?
        }
        
        // The value in the flatLoadAdd field should either be a Double or the literal "nil".
        let flatLoadAdd = json["flatLoadAdd"]
        
        if flatLoadAdd is String && (flatLoadAdd as! String) == "nil" {
            self.flatLoadAdd = nil
        } else {
            self.flatLoadAdd = (flatLoadAdd as! NSNumber?)
        }
        
        // In the JSON files generate PR is an int where 1 is true and 0 (or anthing else) is false.
        self.generatePr = (json["generatePr"] as! Int) == 1
    }
    
    // MARK: Protocol implementation
        
    typealias ParentType = TemplateSet
    
    // Protocol implementation
    var parent: TemplateSet {
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
                return String(format: "%.0f", self.triggerQuantity) + " reps"
            
            case .Time:
                return String(format: "%.2f", self.triggerQuantity) + " seconds"
        }
    }
    
    /// Use this property to trigger a SetThreshold
    public func trigger(loadDone: Double, quantityDone: Double) -> Void {
        
        let templateSet = self.templateSet!
        
        let flatLoadAdd = self.flatQuantityAdd?.doubleValue ?? 0
        
        let flatQuantityAdd = self.flatQuantityAdd?.doubleValue ?? 0
        
        let thresholdShouldTrigger = quantityDone >= self.triggerQuantity
        
        /* If a threshold takes away load or quantity it should only be
         triggered when the quantity done is below the triggerQuantity */
        let thresholdShouldModify = !( (flatQuantityAdd < 0 || flatLoadAdd < 0) && thresholdShouldTrigger )
        
        // Generates a PR
        if self.generatePr {
            
            let exercise = templateSet.exercise!
            let computedLoad: Double
            let computedQuantity: Double
            
            // if onerepmax pr and load done isnt 1 use Brzyckis formula to approximate.
            if self.prType! == "onerepmax" && loadDone != 1 {
                computedQuantity = 1
                computedLoad = loadDone / (1.0278 - (0.0278 * quantityDone))
            } else {
                computedQuantity = quantityDone
                computedLoad = loadDone
            }
            
            // Generate the PersonalRecord.
            let _ = PersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                weightLoad: computedLoad,
                quantity: computedQuantity,
                date: Date(),
                type: self.prType!
            )
        }
        
        if thresholdShouldModify {
            
            // Adds the flat load.
            if self.flatLoadAdd != nil && thresholdShouldTrigger {
                
                templateSet.setLoad += self.flatLoadAdd!.doubleValue
            }
            
            // Adds the flat quantity
            if self.flatQuantityAdd != nil && thresholdShouldTrigger {
                
                templateSet.setQuantity += self.flatQuantityAdd!.doubleValue
                
                // Adds the quantity added to the template to itself the ensure linearity.
                self.triggerQuantity += self.flatQuantityAdd!.doubleValue
            }
            
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
