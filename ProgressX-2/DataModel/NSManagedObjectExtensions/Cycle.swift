//
//  Cycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation

extension Cycle {
    
    // MARK: Extra properties
    
    var cycleName: String {
        return "Cycle \(self.positionIndex)"
    }
    
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.weeks == nil {
            throw NSValidationErrors.cycleCompleteWithNoWeeks.toNSError()
        }
        
        // If Cycle is complete but it's weeks arent throw an error.
        var completedWeeks: Int = 0
        let weeks = self.weeks!.allObjects as! [TrainingWeek]
        
        // Count completed weeks.
        for week in weeks {
            if week.isComplete {
                completedWeeks += 1
            }
        }
        
        // Throw if true.
        if self.isComplete && completedWeeks != weeks.count {
            throw NSValidationErrors.cycleCompleteWithUncompleteWeeks.toNSError()
        }
    }
}
