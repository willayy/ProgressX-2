//
//  Set.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension TrainingSet {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        trainingSession: TrainingSession,
        templateSet: TemplateSet
    ) {
        self.init(context: context)
        self.trainingSession = trainingSession
        let positionIndex = trainingSession.getNextPositionIndex()
        let exercise = templateSet.exercise!
        self.exercise = exercise
        self.positionIndex = positionIndex
        self.templateSet = templateSet
        self.loadTodo = templateSet.loadTodo!
        self.quantityTodo = templateSet.quantityTodo!
        self.timePeriodName = templateSet.timePeriodName
        self.timePeriodDescription = templateSet.timePeriodDescription
        self.startedOnDate = Date()
        self.restTime = templateSet.restTime
        trainingSession.addToTrainingSets(self)
    }
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise. Returns nil if exercise is not set.
    public var setExerciseName: String? {
        guard let exercise = self.exercise else { return nil }
        return exercise.exerciseName
    }
    
    /// Uset his property to print the load todo on a set.
    public var loadTodoString: String {
        let context = self.managedObjectContext!
        let weightUnit = PersistenceController.getWeightUnit(context)!
        return "\(String(format: "%.2f", self.loadTodo)) \(weightUnit)"
    }
    
    /// Use this to property to print the load done on a set.
    public var loadDoneString: String {
        let context = self.managedObjectContext!
        let weightUnit = PersistenceController.getWeightUnit(context)!
        return "\(String(format: "%.2f", self.loadDone)) \(weightUnit)"
    }
    
    /// Use this to property to print the quantity todo on a set. Returns nil if exercise type is not not set or is invalid
    public var quantityTodoString: String? {
        guard let exerciseType = self.exercise?.exerciseType else { return nil }
        guard let type: ExerciseType = ExerciseType(rawValue: exerciseType) else { return nil }
        
        switch type {
        case .Reps:
            return String(format: "%.0f", self.quantityTodo) + " reps"
        case .Time:
            return String(format: "%.2f", self.quantityTodo) + " seconds"
        }
    }
    
    /// Use this to property to print the quantity done on a set. Returns nil if exercise type is not not set or is invalid
    public var quantityDoneString: String? {
        guard let exerciseType = self.exercise?.exerciseType else { return nil }
        guard let type: ExerciseType = ExerciseType(rawValue: exerciseType) else { return nil }
        
        switch type {
            case .Reps:
                return String(format: "%.0f", self.quantityDone) + " reps"
            case .Time:
                return String(format: "%.2f", self.quantityDone) + " seconds"
        }
    }
    
    // MARK: Validation
    
    // Override validation
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateQuantityTodo()
        try validateQuantityDone()
    }
    
    // Override validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateQuantityTodo()
        try validateQuantityDone()
    }

    private func validateQuantityTodo() throws {
        let isQuantityTodoInteger = (floor(self.quantityTodo) == self.quantityTodo)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityTodoInteger && isPrRepBased {
            throw ValidationNSErrors.quantityTodoIsInvalid.toNSError()
        }
    }
    
    private func validateQuantityDone() throws {
        let isQuantityDoneInteger = (floor(self.quantityDone) == self.quantityDone)
        let isPrRepBased = (self.exercise!.exerciseType == "reps")
        if !isQuantityDoneInteger && isPrRepBased {
            throw ValidationNSErrors.quantityDoneIsInvalid.toNSError()
        }
    }
}

