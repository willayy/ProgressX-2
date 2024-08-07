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
    
    /// The completion date of a Completable object as a String.
    public var completionDateString: String? {
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
    }
    
    /// Skips a Completeable TimePeriod.
    public func skip(onDate: Date = Date()) -> Void {
        self.isComplete = true
        self.completedOnDate = onDate
        
        // Handle extra stuff if its a trainingset
        if self is TrainingSet {
            let trainingSet: TrainingSet = self as! TrainingSet
            trainingSet.quantityDone = 0
            trainingSet.loadDone = 0
        }
    }
    
    //MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
        cascadeCompletion()
    }
    
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
    
    private func validateIsComplete() throws {
        if self.isComplete && self.completedOnDate == nil {
            throw ValidationNSErrors.completeWithoutCompletionDate.toNSError()
        }
    }

}
