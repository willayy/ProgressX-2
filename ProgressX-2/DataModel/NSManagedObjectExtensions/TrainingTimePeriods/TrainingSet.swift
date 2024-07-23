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
        templateSet: TemplateSet,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.trainingSession = trainingSession
        let positionIndex = trainingSession.getNextPositionIndex()
        let exercise = templateSet.exercise!
        self.exercise = exercise
        self.positionIndex = positionIndex
        self.templateSet = templateSet
        self.loadTodo = templateSet.loadTodo
        self.quantityTodo = templateSet.quantityTodo
        self.timePeriodName = (name == "") ? "Set \(positionIndex)" : name
        let exerciseName = exercise.exerciseName!
        let sessionName = trainingSession.timePeriodName!
        self.timePeriodDescription = (description == "") ? "\(exerciseName) set in \(sessionName)" : description
        self.startedOnDate = Date()
        trainingSession.addToTrainingSets(self)
    }
    
    // MARK: Extra properties
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    var setExerciseName: String? {
        return self.exercise!.exerciseName
    }
    
    /// Uset his property to print the load todo on a set.
    var loadTodoString: String {
        return String(format: "%.2f", self.loadTodo)
    }
    
    /// Use this to property to print the load done on a set.
    var loadDoneString: String {
        return String(format: "%.2f", self.loadDone)
    }
    
    /// Use this to property to print the quantity todo on a set.
    var quantityTodoString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
        switch type {
        case .Reps:
            return String(format: "%.0f", self.quantityTodo) + " reps"
        case .Time:
            return String(format: "%.2f", self.quantityTodo) + " seconds"
        }
    }
    
    /// Use this to property to print the quantity done on a set.
    var quantityDoneString: String {
        let type: ExerciseType = ExerciseType(rawValue: self.exercise!.exerciseType!)!
        
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

