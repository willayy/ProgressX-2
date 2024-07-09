//
//  Cycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingCycle: HasOrderable {
    
    // MARK: Extra properties
    
    func getNextPositionIndex() -> Int64 {
        let weeks: [TrainingWeek] = self.trainingWeeks?.allObjects as! [TrainingWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
        try validatePositionIndexes()
        try validateCompleteables()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
        try validatePositionIndexes()
        try validateCompleteables()
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let weeks: [TrainingWeek] = self.trainingWeeks?.allObjects as! [TrainingWeek]
        let groupedBy = Dictionary(grouping: weeks, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateIsComplete() throws {
        
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.trainingWeeks!.allObjects.isEmpty {
            throw ValidationNSErrors.cycleCompleteWithNoWeeks.toNSError()
        }
        
        // If Cycle is complete but it's weeks arent throw an error.
        var completedWeeks: Int = 0
        let weeks = self.trainingWeeks!.allObjects as! [TrainingWeek]
        
        // Count completed weeks.
        for week in weeks {
            if week.isComplete {
                completedWeeks += 1
            }
        }
        
        // Throw if true.
        if self.isComplete && completedWeeks != weeks.count {
            throw ValidationNSErrors.cycleCompleteWithUncompleteWeeks.toNSError()
        }
    }
    
    private func validateCompleteables() throws {
        #warning("TODO: Implement with cycleIncompleWithCompleteWeeks")
        #warning("DONT FORGET TO IMPLEMENT VALIDATION ERROR")
    }
    
}
