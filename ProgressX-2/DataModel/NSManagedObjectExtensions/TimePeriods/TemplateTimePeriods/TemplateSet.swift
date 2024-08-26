//
//  TemplateSet.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateSet: HasOrderable, HasParent, HasChildren {
    
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
    
    /// Initializer for a TemplateSet using JSON data
    convenience init(
        _ context: NSManagedObjectContext,
        templateSession: TemplateSession,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.templateSession = templateSession
        templateSession.addToTemplateSets(self)
        self.positionIndex = templateSession.getNextPositionIndex()
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
        self.loadType = (json["loadType"] as! String)
        self.setLoad = (json["setLoad"] as! Double)
        self.quantityType = (json["quantityType"] as! String)
        self.setQuantity = (json["setQuantity"] as! Double)
        self.restTime = (json["restTime"] as! Double)
        self.exercise = CoreDataAccess.getExercise(context, name: json["exercise"] as! String)
    }
    
    // MARK: Protocol implementation
        
    typealias ParentType = TemplateSession
    
    typealias ChildrenType = SetThreshold
    
    var children: [SetThreshold] {
        return self.thresholds!.allObjects as! [SetThreshold]
    }
    
    // Protocol implementation
    var parent: TemplateSession {
        return self.templateSession!
    }
    
    // Protocol implementation
    public func getNextPositionIndex() -> Int64 {
        let thresholds: [SetThreshold] = self.thresholds?.allObjects as! [SetThreshold]
        let max = thresholds.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    func getPositionIndexes() -> [Int64] {
        let children = self.thresholds!.allObjects as! [SetThreshold]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
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
            let latestPr = CoreDataAccess.getLatestPersonalRecord(
                self.managedObjectContext!,
                exercise: exercise,
                prType: prType
            )
            // Compute the percentage
            let computedLoad: Double = (latestPr?.weightLoad ?? 0) * (self.setLoad / 100)
            // Round to smallest plate
            let profile = CoreDataAccess.getProfile(context)
            let smallestPlate = profile!.smallestPlate * 2 // times two because you always add two weights for balance
            let roundedLoad: Double = (computedLoad / smallestPlate).rounded() * smallestPlate
            return roundedLoad
            
        case .bodyWeightPercentage:
            let latestBw = CoreDataAccess.getLatestBodyEntry(context)
            let computedLoad: Double = (latestBw?.bodyWeight ?? 0) * (self.setLoad / 100)
            guard let profile = CoreDataAccess.getProfile(context) else { return nil }
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
            let latestPr = CoreDataAccess.getLatestPersonalRecord(context, exercise: exercise, prType: prType)
            var computedQuantity: Double = (latestPr?.prQuantity ?? 0) * (self.setQuantity / 100)
            if exercise.exerciseType! == "reps" { computedQuantity = floor(computedQuantity) }
            return computedQuantity
        }
    }
    
    /// Use this property for printing the load to be done on a set. Returns nil if loadType, context, weightUnit is not set or if loadType is invalid.
    public var setLoadString: String? {
        guard let loadType = self.loadType else { return nil }
        guard let loadTypeEnum = LoadType(rawValue: loadType) else { return nil }
        guard let context = self.managedObjectContext else { return nil }
        guard let weightUnit = CoreDataAccess.getWeightUnit(context) else { return nil }
        
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
    
    /// Returns the templateSets rest time double attribute as a formatted string.
    public var formattedRestTime: String {
        return String(format: "%.2f", self.restTime)
    }
        
    // MARK: Validation
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateQuantityTodo()
    }
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateQuantityTodo()
    }
    
    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo!) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoIsInvalid.toNSError()
        }
    }
}
