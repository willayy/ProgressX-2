//
//  Completable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension CompleteableTimePeriod {
    
    //MARK: Extra properties
    
    /// The completion date of a Completable object as a formatted String.
    public var formattedCompletionDate: String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.completedOnDate != nil {
            return df.string(from: self.completedOnDate!)
        }
        
        else {
            return nil
        }
    }
    
    /// Marks a Completable TimePeriod as completed.
    public func complete(onDate: Date = Date()) -> Void {
        self.isComplete = true
        self.completedOnDate = onDate
        
        // Check thresholds if a TrainingSet is completed.
        // This cant be overidden in TrainingSet because its declared in an extension
        if self is TrainingSet {
            let trainingSet: TrainingSet = self as! TrainingSet
            let templateSet: TemplateSet = trainingSet.templateSet!
            let thresholds = templateSet.thresholds!.allObjects as! [SetThreshold]
            
            for threshold in thresholds {
                if threshold.triggerQuantity >= trainingSet.quantityDone {
                    threshold.trigger(loadDone: trainingSet.loadDone, quantityDone: trainingSet.quantityDone)
                }
            }
        }
        
        self.cascadeCompletion()
    }
    
    /// Skips a Completeable TimePeriod.
    public func skip(onDate: Date = Date()) -> Void {
        self.isComplete = true
        self.completedOnDate = onDate
        
        // Handle extra stuff if its a trainingset
        // This cant be overidden in TrainingSet because its declared in an extension
        if self is TrainingSet {
            let trainingSet: TrainingSet = self as! TrainingSet
            trainingSet.quantityDone = 0
            trainingSet.loadDone = 0
        }
    }
    
    /* The cascadeCompletion method is not really what i want it to be, the issue is mainly that all
     the different entities who have a relationship to a parent have different names for this relationship.
     If all the etiteis with parents hade the same name for their parent relationship this could be made much shorter
     and concise by using a single key to access all parent values. The parent values could then be cast to
     HasCompleteable. */
    
    /// If a child is completed and all its parent children are now complete, make parent complete.
    private func cascadeCompletion() {

        switch self {
            
        case is TrainingWeek:
            
            let trainingWeek = self as! TrainingWeek
            let trainingCycle = trainingWeek.trainingCycle!
            if trainingCycle.childrenAreComplete() && !trainingCycle.isComplete {
                trainingCycle.complete()
            }
            
        case is TrainingSession:
            
            let trainingSession = self as! TrainingSession
            let trainingWeek = trainingSession.trainingWeek!
            if trainingWeek.childrenAreComplete() && !trainingWeek.isComplete {
                trainingWeek.complete()
            }
            
        case is TrainingSet:
            
            let trainingSet = self as! TrainingSet
            let trainingSession = trainingSet.trainingSession!
            if trainingSession.childrenAreComplete() && !trainingSession.isComplete {
                trainingSession.complete()
            }
            
        default:
            break
        }
    }
    
    //MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateCompletedHasCompletionDate()
        if self is HasCompleteable {
            try validateHasCompletables()
        }
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateCompletedHasCompletionDate()
        if self is HasCompleteable {
            try validateHasCompletables()
        }
    }
    
    /// Checks that a completed CompletableTimePeriod has a set completionDate
    private func validateCompletedHasCompletionDate() throws {
        // If CompletableTimePeriod is marked as completed but lacks a completion date throw an error.
        if self.isComplete && self.completedOnDate == nil {
            throw ValidationNSErrors.completeWithoutCompletionDate.toNSError()
        }
    }
    
    /// Checks that the relationship between a CompletableTimePeriod and its Completeable Children is valid
    private func validateHasCompletables() throws {
        let selfAsHasCompletable: HasCompleteable = self as! HasCompleteable
        
        // if session is complete and its relationship sets is empty throw an error
        if self.isComplete && !selfAsHasCompletable.hasCompleteableChildren() {
            throw ValidationNSErrors.completeWithNoChildren.toNSError()
        }
        
        // If session is complete but it's sets arent throw an error
        if self.isComplete && !selfAsHasCompletable.childrenAreComplete() {
            throw ValidationNSErrors.completeWithUncompleteChildren.toNSError()
        }
        
        // If session is incomplete but its sets are completed
        if !self.isComplete && selfAsHasCompletable.childrenAreComplete() {
            throw ValidationNSErrors.InCompleteWithCompleteChildren.toNSError()
        }
    }

}
