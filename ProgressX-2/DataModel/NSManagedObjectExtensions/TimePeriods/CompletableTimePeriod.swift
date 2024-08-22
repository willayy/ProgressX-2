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
        
        self.cascadeCompletion()
    }
    
    /// If a child is completed and all its parent children are now complete, make parent complete.
    private func cascadeCompletion() {
        if let completableWithParent = self as? (any HasParent) {
            let parent = completableWithParent.parent
            // Forced cast because if self has parent, parent is HasCompleteable
            if (parent as! HasCompleteable).childrenAreComplete() {
                /* If parent is completeable, this needs to be checked since routines are parents
                 but not completeable. */
                if let completableParent = parent as? CompleteableTimePeriod {
                    completableParent.complete()
                }
            }
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
