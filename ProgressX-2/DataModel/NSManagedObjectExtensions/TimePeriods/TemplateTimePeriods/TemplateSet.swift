//
//  TemplateSet.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateSet: HasOrderable {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        templateSession: TemplateSession,
        name: String = "",
        description: String = "",
        exercise: Exercise,
        loadType: String,
        load: Double,
        quantityType: String,
        quantity: Double,
        restTime: Double
    ) {
        self.init(context: context)
        self.templateSession = templateSession
        self.exercise = exercise
        let positionIndex = templateSession.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.loadType = loadType
        self.setLoad = load
        self.quantityType = quantityType
        self.setQuantity = quantity
        self.timePeriodName = (name == "") ? "Set \(positionIndex)" : name
        let exerciseName = exercise.exerciseName!
        let sessionName = templateSession.timePeriodName!
        self.timePeriodDescription = (description == "") ? "\(exerciseName) set in \(sessionName)" : description
        self.restTime = restTime
        templateSession.addToTemplateSets(self)
    }
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    public var setExerciseName: String? {
        return self.exercise?.exerciseName
    }
    
    /// Use this property as the single source of truth for the load, in kg's or lbs, to be done on this set. returns nil if loadType is not set, is invalid, context is not set or Profile doesnt exist.
    public var loadTodo: Double? {
        guard let loadType = self.loadType else { return nil }
        guard let loadTypeEnum = LoadType(rawValue: loadType) else { return nil }
        guard let context = self.managedObjectContext else { return nil }
                
        switch loadTypeEnum {
        case .numerical:
            return self.setLoad
            
        case .maxPercentage:
            let exercise = self.exercise!
            let prType = exercise.exerciseType == "reps" ? "onerepmax" : "timemax"
            let latestPr = PersistenceController.getLatestPersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                prType: prType
            )
            // Compute the percentage
            let computedLoad: Double = (latestPr?.weightLoad ?? 0) * (self.setLoad / 100)
            // Round to smallest plate
            let profile = PersistenceController.getProfile(context)
            let smallestPlate = profile!.smallestPlate * 2 // times two because you always add two weights for balance
            let roundedLoad: Double = (computedLoad / smallestPlate).rounded() * smallestPlate
            return roundedLoad
            
        case .bodyWeightPercentage:
            let latestBw = PersistenceController.getLatestBodyEntry(context)
            let computedLoad: Double = (latestBw?.bodyWeight ?? 0) * (self.setLoad / 100)
            guard let profile = PersistenceController.getProfile(context) else { return nil }
            let smallestPlate = profile.smallestPlate * 2 // times two because you always add two weights for balance
            let roundedLoad: Double = (computedLoad / smallestPlate).rounded() * smallestPlate
            return roundedLoad
        }
    }
    
    /// Use this property as the single source of truth for the quantity, in reps or seconds, to be done on this set. Returns nil if quantityp is not set, is invalid or context is not set.
    public var quantityTodo: Double? {
        guard let quantityType = self.quantityType else { return nil }
        guard let quantityTypeEnum = QuantityType(rawValue: quantityType) else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        
        switch quantityTypeEnum {
        case .numerical:
            return self.setQuantity
            
        case .maxPercentage:
            let exercise = self.exercise!
            let prType = exercise.exerciseType == "reps" ? "maxreps" : "timemax"
            let latestPr = PersistenceController.getLatestPersonalRecord(context, exercise: exercise, prType: prType)
            var computedLoad: Double = (latestPr?.prQuantity ?? 0) * (self.setQuantity / 100)
            if exercise.exerciseType! == "reps" { computedLoad = floor(computedLoad) }
            return computedLoad
        }
    }
    
    /// Use this property for printing the load to be done on a set. Returns nil if loadType, context, weightUnit is not set or if loadType is invalid.
    public var setLoadString: String? {
        guard let loadType = self.loadType else { return nil }
        guard let loadTypeEnum = LoadType(rawValue: loadType) else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        guard let weightUnit = PersistenceController.getWeightUnit(context) else { return nil }
        
        switch loadTypeEnum {
        case .numerical:
            return String(format: "%.2f", self.setLoad) + " \(weightUnit)"
            
        case .maxPercentage:
            return (String(format: "%.2f", self.setLoad) + "% of max")
            
        case .bodyWeightPercentage:
            return (String(format: "%.2f", self.setLoad) + "% of bodyweight")
        }
    }
    
    /// Use this property for printing the quantity to be done on a set, returns nil if quantityType, exercise, exerciseType, is not set or is invalid.
    public var setQuantityString: String? {
        guard let quantityType = self.quantityType else { return nil }
        guard let quantityTypeEnum = QuantityType(rawValue: quantityType) else { return nil }
        guard let exercise = self.exercise else { return nil }
        guard let exerciseType = exercise.exerciseType else { return nil }
        guard let exerciseTypeEnum = ExerciseType(rawValue: exerciseType) else { return nil }
        
        switch quantityTypeEnum {
            case .numerical:
                switch exerciseTypeEnum {
                    case .Reps:
                        return (String(format: "%.0f", self.setQuantity) + " reps")
                    case .Time:
                        return (String(format: "%.2f", self.setQuantity) + " seconds")
                    }
            case .maxPercentage:
                return (String(format: "%.2f", self.setQuantity) + "% of max")
        }
    }
    
    public var restTimeString: String {
        return String(format: "%.2f", self.restTime)
    }
        
    /// Gets the next position index for the thresholds in this set
    public func getNextPositionIndex() -> Int64 {
        let thresholds: [SetThreshold] = self.thresholds?.allObjects as! [SetThreshold]
        let max = thresholds.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // MARK: Validation
    
    // Override validation
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateQuantityTodo()
        try validatePositionIndexes()
    }
    
    // Override validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateQuantityTodo()
        try validatePositionIndexes()
    }
    
    private func validatePositionIndexes() throws {
        let thresholds: [SetThreshold] = self.thresholds?.allObjects as! [SetThreshold]
        let groupedBy = Dictionary(grouping: thresholds, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo!) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoIsInvalid.toNSError()
        }
    }
}
