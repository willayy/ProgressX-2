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
    
    var completionDateString: String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.completedOnDate != nil {
            return df.string(from: self.completedOnDate!)
        }
        
        else {
            return nil
        }
    }
    
    /// Marks object as completed
    public func complete(onDate: Date = Date()) -> Void {
        self.isComplete = true
        self.completedOnDate = onDate
    }
    
    //MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
    }
    
    private func validateIsComplete() throws {
        if self.isComplete && self.completedOnDate == nil {
            throw ValidationNSErrors.completeWithoutCompletionDate.toNSError()
        }
    }

}
